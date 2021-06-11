------------------ Estrategico ----------------------
-- 1) Top 5 cursos mais vendidos
-- 2) Top 5 cursos menos vendidos
-- 3) Top 5 categorias menos vendidas
-- 4) Top 5 cursos menores notas

--1) Estratégico
select 
    *
from
    (
        select
            dense_rank() over (order by count(*) desc) as posicao,
            cur_nome as "Curso Nome",
            pes_prim_nome || ' ' || pes_ult_nome as Nome,
            count(com_cur_id) as "Quantidade Vendida"
        from 
            compras_cursos
        inner join cursos
            on cur_id = com_cur_id
        inner join autores
            on aut_pes_id = cur_aut_pes_id
        inner join pessoas
            on pes_id = aut_pes_id
        group by 
            com_cur_id, cur_nome, pes_prim_nome || ' ' || pes_ult_nome
        order by
            "Quantidade Vendida" desc
    )
where posicao <= 5

--2) Estratégico
select 
    *
from
    (
        select 
            dense_rank() over (order by count(*)) as "Posicao",
            cur_nome as "Curso Nome",
            pes_prim_nome || ' ' || pes_ult_nome as "Nome",
            count(com_cur_id) as "Quantidade Vendida"
        from 
            compras_cursos
        inner join cursos
            on cur_id = com_cur_id
        inner join autores
            on aut_pes_id = cur_aut_pes_id
        inner join pessoas
            on pes_id = aut_pes_id
        group by 
            com_cur_id, cur_nome, pes_prim_nome || ' ' || pes_ult_nome
        order by
            "Quantidade Vendida"
    )
where posicao <= 5

-- 3) Estratégico
select 
    *
from
    (
        select 
            dense_rank() over (order by count(*) desc) as "Posicao",
            ctg_nome,
            count(com_cur_id) as "Quantidade Vendida"
        from 
            compras_cursos
        inner join cursos
            on cur_id = com_cur_id
        inner join categorias
            on ctg_id = cur_ctg_id
        group by 
            ctg_nome
        order by
            "Quantidade Vendida" desc
    )
where posicao <= 5 
    
--4) Estratégico
select 
    posicao as "Posição",
    cur_nome as "Curso Nome",
    to_char(Media_Nota, 'fm90.00') as "Media Nota"
from
    (
        SELECT
            dense_rank() over (order by avg(com_nota_teste)) as posicao,
            cur_nome,
            round(avg(com_nota_teste), 2) as Media_Nota
        FROM
            compras_cursos
        INNER JOIN cursos
            on cur_id = com_cur_id
        GROUP BY
            cur_nome
        Order by
            Media_Nota
    )
where posicao <= 5