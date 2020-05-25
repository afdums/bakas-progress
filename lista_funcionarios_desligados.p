
FOR EACH funcionario
    WHERE funcionario.dat_desligto_func >= TODAY - 7 NO-LOCK:

    DISP funcionario.cdn_estab
         funcionario.cdn_funcionario
         funcionario.nom_pessoa
         funcionario.dat_admis_func
         funcionario.dat_desligto_func.

END.
