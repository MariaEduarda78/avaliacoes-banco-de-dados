USE RedeSocial;
-- 1) Usuários que fizeram pelo menos uma postagem.
select u.id,u.nome from usuarios u
where exists (select p.id from postagens p where p.usuario_id = u.id);

-- 2) Todas as postagens e adicione uma coluna chamada numero_curtidas, mostrando quantas curtidas cada postagem recebeu.
select p.id AS id_postagem,p.conteudo AS conteudo_postagem,
(SELECT count(*) from curtidas c where p.id = c.postagem_id) AS total_curtidas
from postagens p;

-- 3) Todas as postagens e o nome do usuário que as criou.
select p.id AS id_postagem,p.conteudo AS conteudo_postagem,u.nome AS usuario from usuarios u
inner join postagens p on u.id = p.usuario_id;

-- 4) Liste todos os usuários e exiba o nome do amigo deles, mesmo que o usuário não tenha amigos ainda.
select u.id AS id_usuario,u.nome AS nome_usuario,u2.nome AS nome_amigo from usuarios u
left join amizades a on u.id = a.usuario_id1 and a.status = "aceita"
left join usuarios u2 on u2.id = a.usuario_id2;

-- 5) Os comentários feitos e o nome do usuário que comentou
select c.id AS id_comentario, c.conteudo AS conteudo_comentario,u.nome AS usuario from comentarios c
inner join usuarios u on u.id = c.usuario_id;
