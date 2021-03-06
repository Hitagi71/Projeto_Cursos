-- Stage Compras
create table stage_compras (
    stg_id_curso number(6),
    stg_id_aluno number(6),
    stg_nota_aluno float(2),
    stg_dia_compra char(2),
    stg_mes_compra char(2),
    stg_ano_compra char(4),
    stg_nome_curso varchar2(255),
    stg_preco_curso number(8,2),
    stg_nome_ctg_curso varchar2(255),
    stg_nome_aut varchar2(62),
    stg_cidade_compra varchar2(255),
    stg_estado_compra varchar2(255),
    stg_idade_aluno number(2)
);

alter table stage_compras add constraint pk_stg_compras primary key (stg_id_aluno, stg_id_curso);

create or replace procedure pr_carga_stage_compras
as
begin
    insert into stage_compras (
        select
            com_cur_id as CURSO_ID,
            com_aln_pes_id as ALUNO_ID,
            com_nota_teste as NOTA_ALUNO,
            to_char(com_dt_compra,'dd') as DIA_COMPRA,
            to_char(com_dt_compra,'mm') as MES_COMPRA,
            to_char(com_dt_compra,'yyyy') as ANO_COMPRA,
            cur_nome as CURSO,
            cur_preco as PRECO_CURSO,
            ctg_nome as CATEGORIA,
            aut.pes_prim_nome || ' ' || aut.pes_meio_nome || ' ' || aut.pes_ult_nome as AUTOR,
            aln_cidade as CIDADE_COMPRA,
            aln_estado as ESTADO_COMPRA,
            trunc((months_between(sysdate, aln_dt_nasc))/12) as IDADE_ALUNO
        from
            compras_cursos
            inner join cursos on cur_id = com_cur_id
            inner join categorias on cur_ctg_id = ctg_id
            inner join autores on cur_aut_pes_id = aut_pes_id
            inner join pessoas aut on aut_pes_id = pes_id
            inner join alunos on com_aln_pes_id = aln_pes_id
    );
end;
/

-- Stage Acessos
create table stage_acessos_alunos (
    stg_id_acesso number(6),
    stg_id_curso number(6),
    stg_id_aluno number(6),
    stg_hora_acesso char(2),
    stg_dia_acesso char(2),
    stg_mes_acesso char(2),
    stg_ano_acesso char(4)
);


alter table stage_acessos_alunos add constraint stg_acessos_alunos_pk primary key (stg_id_acesso);

create sequence sq_stg_acessos nocycle nocache;

create trigger tg_seq_stg_acessos before insert on stage_acessos_alunos for each row
begin
    :new.stg_id_acesso := sq_stg_acessos.nextval;
end;
/

create or replace procedure pr_carga_stage_acessos
as
begin
    insert into stage_acessos_alunos (
        select
            com_cur_id as CURSO_ID,
            com_aln_pes_id as ALUNO_ID,
            to_char(com_dt_ultimo_acesso,'HH24') as HORA_ACESSO,
            to_char(com_dt_ultimo_acesso,'dd') as DIA_ACESSO,
            to_char(com_dt_ultimo_acesso,'mm') as MES_ACESSO,
            to_char(com_dt_ultimo_acesso,'yyyy') as ANO_ACESSO
        from
            compras_cursos
    );
end;
/

create or replace procedure atualiza_acesso(id_cur IN number, id_aln IN number)
AS
BEGIN
    update 
        compras_cursos 
    set 
        com_dt_ultimo_acesso = SYSDATE 
    where 
        com_cur_id = id_cur and com_aln_pes_id = id_aln;
    
    pr_carga_stage_acessos();
END;
/