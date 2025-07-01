-- va3 Maria Eduarda
use redesocial;
select * from usuarios;

-- a) Adicionar a coluna ultima_postagem à tabela usuarios
alter table usuarios add column ultima_postagem datetime;

-- b) Preencher a coluna com os dados atuais
update usuarios u
join (select usuario_id, MAX(data_postagem) as postagem_ultima from postagens
group by usuario_id) p on u.id = p.usuario_id
set u.ultima_postagem = p.postagem_ultima;

-- c) Criando a trigger 
DELIMITER $$ 
create trigger tg_incrementar_postagem 
after insert on postagens 
for each row
begin 
update usuarios set ultima_postagem = new.data_postagem
where id = new.usuario_id;
end $$

-- 1) Verificar valor atual de um usuário
SELECT nome, ultima_postagem FROM usuarios WHERE id = 7;
 
 -- 2) Inserir uma nova postagem
insert into postagens (usuario_id, conteudo, data_postagem) values (7, 'Um cantinho feliz.', NOW());

-- 3) Verificar novamente se ultima_postagem foi atualizada
select nome, ultima_postagem from usuarios where id = 7; 

-- Exercício 2) Exibir todas as postagens com o nome do autor e o número total de curtidas.
CREATE VIEW vw_curtidas_por_postagem AS
SELECT p.id AS postagem_id, p.conteudo AS conteudo_da_postagem, u.nome AS nome_autor, COUNT(c.id) AS total_curtidas
FROM postagens p
JOIN usuarios u ON p.usuario_id = u.id
LEFT JOIN curtidas c ON p.id = c.postagem_id
GROUP BY p.id, p.conteudo, u.nome;

select * from vw_curtidas_por_postagem;

-- Exercício 3) Exibir usuários que possuem mais de 3 amizades aceitas.
create view vw_usuarios_com_mais_tres_amigos as 
select u.id as autor_id, u.nome as nome_usuario, count(a.id) as total_de_amigos
from usuarios u
join amizades a on u.id = a.usuario_id1 or u.id = a.usuario_id2 
group by u.id, u.nome
having count(a.id) > 3;

select * from vw_usuarios_com_mais_tres_amigos;

-- Exercício 4) Listar todas as postagens que ainda não receberam nenhum comentário.
create view vw_postagens_sem_comentarios as 
select p.id as postagem_id, p.conteudo as conteudo_da_postagem
from postagens p 
left join comentarios cm on p.id = cm.postagem_id
where cm.id is null;

select * from vw_postagens_sem_comentarios;



