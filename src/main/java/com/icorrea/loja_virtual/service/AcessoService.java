package com.icorrea.loja_virtual.service;

import com.icorrea.loja_virtual.models.Acesso;
import com.icorrea.loja_virtual.repository.AcessoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class AcessoService {

    @Autowired
    private AcessoRepository acessoRepository;

    public Acesso save(Acesso acesso) {
        return acessoRepository.save(acesso);
    }

}