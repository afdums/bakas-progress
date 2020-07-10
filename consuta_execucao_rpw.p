OUTPUT TO c:\temp\teste.csv.
EXPORT DELIMITER ";"
    "dat_criac_ped_exec"       
    "hra_criac_ped_exec"       
    "dat_inic_exec_servid_exec"
    "hra_inic_exec_servid_exec"
    "dat_fim_exec_servid_exec" 
    "hra_fim_exec_servid_exec".

FOR EACH ped_exec
    WHERE ped_exec.cod_prog_Dtsul = "et3103"
      AND Ped_exec.dat_criac_ped_exec >= 06/01/2020 NO-LOCK:
    EXPORT DELIMITER ";"
            ped_exec.dat_criac_ped_exec
            ped_exec.hra_criac_ped_exec
            ped_exec.dat_inic_exec_servid_exec
            ped_exec.hra_inic_exec_servid_exec 
            ped_exec.dat_fim_exec_servid_exec
            ped_exec.hra_fim_exec_servid_exec.
END.
OUTPUT CLOSE.
