package com.icorrea.loja_virtual;

import com.icorrea.loja_virtual.dto.ObjetoErroDTO;
import org.hibernate.exception.ConstraintViolationException;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.ObjectError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.method.annotation.MethodArgumentTypeMismatchException;

import java.sql.SQLException;
import java.util.List;

@RestControllerAdvice
public class ControleExcecoes {

    @ExceptionHandler({ExceptionLojaVirtual.class})
    public ResponseEntity<Object> handleExeptionCustom (ExceptionLojaVirtual ex) {
        ObjetoErroDTO erro = new ObjetoErroDTO();
        erro.setError(ex.getMessage());
        erro.setCode(HttpStatus.OK.toString());

        return new ResponseEntity<Object>(erro, HttpStatus.OK);
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ObjetoErroDTO> handleValidationExceptions(MethodArgumentNotValidException ex) {
        ObjetoErroDTO obj = new ObjetoErroDTO();
        StringBuilder msg = new StringBuilder();

        List<ObjectError> list = ex.getBindingResult().getAllErrors();
        for (ObjectError objectError : list) {
            msg.append(objectError.getDefaultMessage()).append("\n");
        }

        obj.setError(msg.toString());
        obj.setCode(HttpStatus.BAD_REQUEST.toString());

        return new ResponseEntity<>(obj, HttpStatus.BAD_REQUEST);
    }

    @ExceptionHandler(MethodArgumentTypeMismatchException.class)
    public ResponseEntity<ObjetoErroDTO> handleTypeMismatchExceptions(MethodArgumentTypeMismatchException ex) {
        ObjetoErroDTO obj = new ObjetoErroDTO();
        obj.setError("Tipo de dado inválido: " + ex.getName() + " deve ser do tipo " + ex.getRequiredType().getSimpleName());
        obj.setCode(HttpStatus.BAD_REQUEST.toString());

        return new ResponseEntity<>(obj, HttpStatus.BAD_REQUEST);
    }

    @ExceptionHandler({DataIntegrityViolationException.class, ConstraintViolationException.class, SQLException.class})
    public ResponseEntity<ObjetoErroDTO> handleExceptionDataIntegrity(Exception ex) {
        ObjetoErroDTO obj = new ObjetoErroDTO();
        String msg;

        if (ex.getCause() != null && ex.getCause().getCause() != null) {
            msg = ex.getCause().getCause().getMessage();
        } else {
            msg = ex.getMessage();
        }

        obj.setError(msg);
        obj.setCode(HttpStatus.INTERNAL_SERVER_ERROR.toString());

        return new ResponseEntity<>(obj, HttpStatus.INTERNAL_SERVER_ERROR);
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ObjetoErroDTO> handleGenericExceptions(Exception ex) {
        ObjetoErroDTO obj = new ObjetoErroDTO();
        obj.setError("Erro inesperado: " + ex.getMessage());
        obj.setCode(HttpStatus.INTERNAL_SERVER_ERROR.toString());

        return new ResponseEntity<>(obj, HttpStatus.INTERNAL_SERVER_ERROR);
    }
}

