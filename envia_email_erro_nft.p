/*alterar para mais de 30 minutos no passado, assim na proxima execução ira enviar o e-mail com os erros do et3103*/
FOR EACH param-espec-nft EXCLUSIVE-LOCK:
    UPDATE param-espec-nft.ultimo-envio-email.
END.
