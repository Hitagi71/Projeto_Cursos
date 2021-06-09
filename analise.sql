------------------ Analise ----------------------
-- faixa etária alunos para cada curso, mais variancia
-- cursos mais vendidos em porcentagem
-- vendas por autor
-- Relação notas categorias/curso

-- 1) 
with idade as (
    select
        aln_pes_id,
        trunc((months_between(sysdate, aln_dt_nasc))/12) as Idade_Aluno
    from
        alunos
) 

select
    cur_nome,
    VARIANCE(idade_aluno) as Variancia,
    case 
        when avg(idade_aluno) < 21 then '0 - 20'
        when avg(idade_aluno) < 31 then '20 - 30'
        when avg(idade_aluno) < 41 then '30 - 40'
        when avg(idade_aluno) < 51 then '40 - 50'
        when avg(idade_aluno) < 61 then '50 - 60'
        else 'Mais de 60'
    end as Faixa
from 
    compras_cursos
inner join 
    alunos
    on aln_pes_id = com_aln_pes_id
inner join cursos
    on cur_id = com_cur_id
 inner join
    idade
    on idade.aln_pes_id = compras_cursos.com_aln_pes_id
group by
    cur_nome
order by 3
    
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
    pes_prim_nome,
    count(com_cur_id)
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
