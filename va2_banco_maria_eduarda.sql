USE redesocial;
-- 1) View de Usuários com Taxa de Resposta a Comentários.
create view view_usuario_resposta as
select u.id as nome_id, u.nome as usuario, count(distinct p.id) as total_de_postagens,
count(cmt.id) as total_de_comentarios,
round(cast(count(cmt.id) as float)/nullif (count(distinct p.id),0),2) as media_de_respostas
from usuarios u
join postagens p on u.id = p.usuario_id
left join comentarios cmt on cmt.postagem_id = p.id 
group by u.id,u.nome;
select * from view_usuario_resposta;

-- 2) View de Postagens sem Nenhuma Interação
create view view_postagens_sem_interacoes as 
select p.id as postagem_id, p.conteudo as conteudo_da_postagem
from postagens p 
left join curtidas c on p.id = c.postagem_id
left join comentarios cmt on p.id = cmt.postagem_id
join usuarios u on p.usuario_id = u.id 
where cmt.id is null and c.id is null;
select * from view_postagens_sem_interacoes;

-- 3) View de Postagens com Nome do Autor
create view view_postagens_autor as
select p.id as postagem_id,p.conteudo as conteudo_da_postagem,u.id as nome_id, u.nome as nome
from usuarios u
inner join postagens p on u.id = p.usuario_id;
select * from view_postagens_autor;

-- 4) View de Top 5 Usuários Mais Engajadores
create view view_mais_engajadores as
select u.id as nome_id,u.nome as nome, count( distinct c.id) + count(distinct cmt.id) as total_de_interacoes
from usuarios u
left join curtidas c on u.id = c.usuario_id
left join postagens pt on c.postagem_id = pt.id and u.id <> pt.usuario_id
left join comentarios cmt on u.id = cmt.usuario_id
left join postagens pt2 on pt2.id = cmt.postagem_id and u.id <> pt2.usuario_id
group by u.id,u.nome
order by total_de_interacoes desc
limit 5;
select * from view_mais_engajadores;

-- 5) View de Estatisticas de Interacoes em Postagens
CREATE VIEW view_estatistica_interacoes_em_postagens AS 
SELECT p.id AS postagem_id, p.conteudo AS conteudo_da_postagem,
count(distinct c.id) as curtidas_total,
count(distinct cmt.id) as comentarios_total
from postagens p
left join curtidas c on p.id = c.postagem_id
left join comentarios cmt on p.id = cmt.postagem_id
group by p.id,p.conteudo;
select * from view_estatistica_interacoes_em_postagens;



