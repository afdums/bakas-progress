/* alterar para qualquer valor maior de 30 minutos atras */
FOR EACH param-espec-nft EXCLUSIVE-LOCK:
    UPDATE param-espec-nft.ultimo-envio-email.
END.
