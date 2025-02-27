package com.icorrea.loja_virtual.repository;

import com.icorrea.loja_virtual.models.Usuario;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UsuarioRepository extends CrudRepository<Usuario, Long> {

    @Query(value = "SELECT u FROM Usuario u WHERE  u.login = ?1")
    Usuario findUserByLogin(String login);
}
