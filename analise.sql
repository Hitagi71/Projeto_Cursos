------------------ Analise ----------------------
-- 1) faixa etária dos alunos cadastrados
-- 2) cursos mais vendidos em porcentagem
-- 3) vendas por autor
-- 4) Relação notas categorias

-- 1) 
with idade as (
    select
        aln_pes_id,
        trunc((months_between(sysdate, aln_dt_nasc))/12) as Idade_Aluno
    from
        alunos
) 

select
    case 
        when idade_aluno < 21 then '0 - 20'
        when idade_aluno < 31 then '20 - 30'
        when idade_aluno < 41 then '30 - 40'
        when idade_aluno < 51 then '40 - 50'
        when idade_aluno < 61 then '50 - 60'
        else 'Mais de 60'
    end as "Faixa etaria",
    count(*) as "Quantidade de alunos"
from 
    alunos
inner join
    idade
    on idade.aln_pes_id = alunos.aln_pes_id
group by case
        when idade_aluno < 21 then '0 - 20'
        when idade_aluno < 31 then '20 - 30'
        when idade_aluno < 41 then '30 - 40'
        when idade_aluno < 51 then '40 - 50'
        when idade_aluno < 61 then '50 - 60'
        else 'Mais de 60'
    end;
    
-- 2)
with total_cursos as (
    select
        count(com_cur_id) as Total
    from
        compras_cursos
) 

select 
    cur_nome,
    round((count(com_cur_id) * 100) / Total, 2) as "Porcentagem de compras"
from 
    compras_cursos
    cross join
        total_cursos
    inner join cursos
        on cur_id = com_cur_id
    group by 
        cur_nome, total
    order by
        2 desc
   
-- 3)
select
    pes_prim_nome as Nome,
    count(com_cur_id) as "Quantidade de cursos vendidos"
from
    compras_cursos
inner join cursos
    on cur_id = com_cur_id
inner join autores
    on aut_pes_id = cur_aut_pes_id
inner join pessoas
    on aut_pes_id = pes_id
group by
    pes_prim_nome
order by 2 desc  

-- 4)
select 
    ctg_nome,
    round(avg(com_nota_teste), 2) as "Media de notas"
from 
    compras_cursos
inner join cursos
    on cur_id = com_cur_id
inner join categorias
    on ctg_id = cur_ctg_id
group by 
    ctg_nome
order by
    2 desc
