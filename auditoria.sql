CREATE  TABLE auditorias(
    aud_id number(6),
    aud_dt_registro date,
    aud_user varchar(30),
    aud_tp_acao varchar(6),
    aud_nm_tabela varchar(30),
    aud_id_linha varchar(13)
);

alter table auditorias add constraint aud_pk primary key (aud_id);

create sequence sq_aud nocycle nocache;

create trigger tg_seq_aud before insert on auditorias for each row
begin
    :new.aud_id := sq_aud.nextval;
end;
/

create procedure proc_insere_audit
    (nm_usuario IN varchar, tp_acao IN varchar, nm_tabela IN varchar, id_linha IN varchar)
IS
BEGIN
    insert into auditorias values (0, sysdate, nm_usuario, tp_acao, nm_tabela, id_linha);
END proc_insere_audit;
/


create or replace trigger tg_aud_ass after insert or delete or update on acessos_colaboradores_cursos for each row
declare
    v_usuario varchar(30);
begin
    select user
    into v_usuario
    from dual;
    
    if inserting then
        proc_insere_audit(v_usuario, 'INSERT', 'Acessos_Colaboradores_Cursos', to_char(:new.ass_cur_id) || ' ' || to_char(:new.ass_clb_pes_id));
    elsif updating then
        proc_insere_audit(v_usuario, 'UPDATE', 'Acessos_Colaboradores_Cursos', to_char(:new.ass_cur_id) || ' ' || to_char(:new.ass_clb_pes_id));
    else
        proc_insere_audit(v_usuario, 'DELETE', 'Acessos_Colaboradores_Cursos', to_char(:new.ass_cur_id) || ' ' || to_char(:new.ass_clb_pes_id));
    end if;
end;
/

create or replace trigger tg_aud_aln after insert or delete or update on alunos for each row
declare
    v_usuario varchar(30);
begin
    select user
    into v_usuario
    from dual;
    
    if inserting then
        proc_insere_audit(v_usuario, 'INSERT', 'Alunos', to_char(:new.aln_pes_id));
    elsif updating then
        proc_insere_audit(v_usuario, 'UPDATE', 'Alunos', to_char(:new.aln_pes_id));
    else
        proc_insere_audit(v_usuario, 'DELETE', 'Alunos', to_char(:old.aln_pes_id));
    end if;
end;
/

create or replace trigger tg_aud_aut after insert or delete or update on autores for each row
declare
    v_usuario varchar(30);
begin
    select user
    into v_usuario
    from dual;
    
    if inserting then
        proc_insere_audit(v_usuario, 'INSERT', 'Autores', to_char(:new.aut_pes_id));
    elsif updating then
        proc_insere_audit(v_usuario, 'UPDATE', 'Autores', to_char(:new.aut_pes_id));
    else
        proc_insere_audit(v_usuario, 'DELETE', 'Autores', to_char(:old.aut_pes_id));
    end if;
end;
/

create or replace trigger tg_aud_clb after insert or delete or update on colaboradores for each row
declare
    v_usuario varchar(30);
begin
    select user
    into v_usuario
    from dual;
    
    if inserting then
        proc_insere_audit(v_usuario, 'INSERT', 'Colaboradores', to_char(:new.clb_pes_id));
    elsif updating then
        proc_insere_audit(v_usuario, 'UPDATE', 'Colaboradores', to_char(:new.clb_pes_id));
    else
        proc_insere_audit(v_usuario, 'DELETE', 'Colaboradores', to_char(:old.clb_pes_id));
    end if;
end;
/

create or replace trigger tg_aud_com after insert or delete or update on compras_cursos for each row
declare
    v_usuario varchar(30);
begin
    select user
    into v_usuario
    from dual;
    
    if inserting then
        proc_insere_audit(v_usuario, 'INSERT', 'Compras_Cursos', to_char(:new.com_cur_id) || ' ' || to_char(:new.com_aln_pes_id));
    elsif updating then
        proc_insere_audit(v_usuario, 'UPDATE', 'Compras_Cursos', to_char(:new.com_cur_id) || ' ' || to_char(:new.com_aln_pes_id));
    else
        proc_insere_audit(v_usuario, 'DELETE', 'Compras_Cursos', to_char(:old.com_cur_id) || ' ' || to_char(:old.com_aln_pes_id));
    end if;
end;
/


create or replace trigger tg_aud_ctg after insert or delete or update on categorias for each row
declare
    v_usuario varchar(30);
begin
    select user
    into v_usuario
    from dual;
    
    if inserting then
        proc_insere_audit(v_usuario, 'INSERT', 'Categorias', to_char(:new.ctg_id));
    elsif updating then
        proc_insere_audit(v_usuario, 'UPDATE', 'Categorias', to_char(:new.ctg_id));
    else
        proc_insere_audit(v_usuario, 'DELETE', 'Categorias', to_char(:old.ctg_id));
    end if;
end;
/

create or replace trigger tg_aud_cur after insert or delete or update on cursos for each row
declare
    v_usuario varchar(30);
begin
    select user
    into v_usuario
    from dual;
    
    if inserting then
        proc_insere_audit(v_usuario, 'INSERT', 'Cursos', to_char(:new.cur_id));
    elsif updating then
        proc_insere_audit(v_usuario, 'UPDATE', 'Cursos', to_char(:new.cur_id));
    else
        proc_insere_audit(v_usuario, 'DELETE', 'Cursos', to_char(:old.cur_id));
    end if;
end;
/

create or replace trigger tg_aud_pes after insert or delete or update on pessoas for each row
declare
    v_usuario varchar(30);
begin
    select user
    into v_usuario
    from dual;
    
    if inserting then
        proc_insere_audit(v_usuario, 'INSERT', 'Pessoas', to_char(:new.pes_id));
    elsif updating then
        proc_insere_audit(v_usuario, 'UPDATE', 'Pessoas', to_char(:new.pes_id));
    else
        proc_insere_audit(v_usuario, 'DELETE', 'Pessoas', to_char(:old.pes_id));
    end if;
end;
/