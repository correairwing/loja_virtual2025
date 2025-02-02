package com.icorrea.webstore;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import com.icorrea.webstore.controller.AcessoController;
import com.icorrea.webstore.model.Acesso;
import com.icorrea.webstore.repository.AcessoRepository;
import com.icorrea.webstore.service.AcessoService;

@SpringBootTest(classes = LojaVirtual2025Application.class )
class LojaVirtual2025ApplicationTests {

	@Autowired
	private AcessoService acessoService;

	@Autowired
	private AcessoRepository acessoRepository;

	@Autowired
	private AcessoController acessoController;

	@Test
	public void testCadastraAcesso() {
		Acesso acesso = new Acesso();

		acesso.setDescricao("ROLE_ADMIN");
		acessoController.salvarAcesso(acesso);
	}

}
