package com.icorrea.loja_virtual.repository;

import java.util.List;

import com.icorrea.loja_virtual.models.Acesso;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;


@Repository
@Transactional
public interface AcessoRepository extends JpaRepository<Acesso, Long>{

    @Query("select a from Acesso a where upper(trim(a.descricao)) like %?1%")
    List<Acesso> findByDescricao(String descricao);
}

