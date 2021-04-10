CREATE  TABLE auditorias(
    aud_id number(6),
    aud_dt_registro date,
    aud_user varchar(30),
    aud_tp_acao varchar(6),
    aud_nm_tabela varchar(30),
    aud_id_linha number(6)
);

alter table auditorias add constraint aud_pk primary key (aud_id);

create sequence sq_aud nocycle nocache;

create trigger tg_aud before insert on auditorias for each row
begin
    :new.aud_id := sq_aud.nextval;
end;
/

create procedure proc_insere_audit
    (nm_usuario IN varchar, tp_acao IN varchar, nm_tabela IN varchar, id_linha IN number)
IS
BEGIN
    insert into auditorias values (0, sysdate, nm_usuario, tp_acao, nm_tabela, id_linha);
END proc_insere_audit;
/

create or replace trigger tg_aud_aln after insert or delete or update on alunos for each row
declare
    v_usuario varchar(30);
begin
    select user
    into v_usuario
    from dual;
    
    if inserting then
        proc_insere_audit(v_usuario, 'INSERT', 'Alunos', :new.aln_pes_id);
    elsif updating then
        proc_insere_audit(v_usuario, 'UPDATE', 'Alunos', :new.aln_pes_id);
    else
        proc_insere_audit(v_usuario, 'DELETE', 'Alunos', :old.aln_pes_id);
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
        proc_insere_audit(v_usuario, 'INSERT', 'Autores', :new.aut_pes_id);
    elsif updating then
        proc_insere_audit(v_usuario, 'UPDATE', 'Autores', :new.aut_pes_id);
    else
        proc_insere_audit(v_usuario, 'DELETE', 'Autores', :old.aut_pes_id);
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
        proc_insere_audit(v_usuario, 'INSERT', 'Categorias', :new.ctg_id);
    elsif updating then
        proc_insere_audit(v_usuario, 'UPDATE', 'Categorias', :new.ctg_id);
    else
        proc_insere_audit(v_usuario, 'DELETE', 'Categorias', :old.ctg_id);
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
        proc_insere_audit(v_usuario, 'INSERT', 'Cursos', :new.cur_id);
    elsif updating then
        proc_insere_audit(v_usuario, 'UPDATE', 'Cursos', :new.cur_id);
    else
        proc_insere_audit(v_usuario, 'DELETE', 'Cursos', :old.cur_id);
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
        proc_insere_audit(v_usuario, 'INSERT', 'Pessoas', :new.pes_id);
    elsif updating then
        proc_insere_audit(v_usuario, 'UPDATE', 'Pessoas', :new.pes_id);
    else
        proc_insere_audit(v_usuario, 'DELETE', 'Pessoas', :old.pes_id);
    end if;
end;
/
