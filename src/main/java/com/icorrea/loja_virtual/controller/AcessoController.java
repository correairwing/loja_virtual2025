package com.icorrea.loja_virtual.controller;

import java.util.List;

import com.icorrea.loja_virtual.ExceptionLojaVirtual;
import com.icorrea.loja_virtual.models.Acesso;
import com.icorrea.loja_virtual.repository.AcessoRepository;
import com.icorrea.loja_virtual.service.AcessoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;


@Controller
public class AcessoController {

    @Autowired
    private AcessoService acessoService;

    @Autowired
    private AcessoRepository acessoRepository;

    @ResponseBody
    @GetMapping(value = "/pesquisarPorDesc/{descricao}")
    public ResponseEntity<List<Acesso>> pesquisarPorDesc(@PathVariable("descricao") String descricao) {
        List<Acesso> acesso = acessoRepository.findByDescricao(descricao.toUpperCase());
        return new ResponseEntity<List<Acesso>>(acesso, HttpStatus.OK);
    }

    @ResponseBody
    @GetMapping(value = "/pesquisarAcessoID/{id}")
    public ResponseEntity<Acesso> pesquisarAcessoID(@PathVariable("id") Long id) throws ExceptionLojaVirtual {
        Acesso acesso =  acessoRepository.findById(id).orElse(null);
        if (acesso == null) {
            throw new ExceptionLojaVirtual("Não foi encontrado registros com o ID: " + id);
        }
        return new ResponseEntity<Acesso>(acesso, HttpStatus.OK);
    }

    @ResponseBody
    @PostMapping(value = "/salvarAcesso")
    public ResponseEntity<Acesso> salvarAcesso(@RequestBody Acesso acesso) throws ExceptionLojaVirtual {

        if (acesso.getId() == null) {
            List<Acesso> acessos = acessoRepository.findByDescricao(acesso.getDescricao().toUpperCase());
            if (!acessos.isEmpty()) {
                throw new ExceptionLojaVirtual("Já existe acesso essa descrição" + acesso.getDescricao());
            }
        }
        
        Acesso acessoSalvo = acessoService.save(acesso);
        return new ResponseEntity<Acesso>(acessoSalvo, HttpStatus.OK);
    }

    @ResponseBody
    @PostMapping(value = "/deletarAcesso")
    public ResponseEntity<?> deletarAcesso(@RequestBody Acesso acesso) {
        acessoRepository.deleteById(acesso.getId());
        return new ResponseEntity("Acesso removido", HttpStatus.OK);
    }

    @ResponseBody
    @DeleteMapping(value = "/deletarAcessoID/{id}")
    public ResponseEntity<?> deletarAcessoID(@PathVariable("id") Long id) {
        acessoRepository.deleteById(id);
        return new ResponseEntity("Acesso removido", HttpStatus.OK);
    }

}
