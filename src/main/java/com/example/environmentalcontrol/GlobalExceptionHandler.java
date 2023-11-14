package com.example.environmentalcontrol;

import org.springframework.web.ErrorResponse;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.servlet.mvc.method.annotation.ResponseEntityExceptionHandler;

import static org.springframework.http.HttpStatus.INTERNAL_SERVER_ERROR;

@RestControllerAdvice
public class GlobalExceptionHandler extends ResponseEntityExceptionHandler {
    @ExceptionHandler(Throwable.class)
    @ResponseStatus(INTERNAL_SERVER_ERROR)
    public ErrorResponse onThrowable(final Throwable ex) {
        logger.error(ex.getMessage(), ex);
        String message = ex.getClass().getName() + ": " + ex.getMessage();
        return ErrorResponse.create(ex, INTERNAL_SERVER_ERROR, message);
    }
}
