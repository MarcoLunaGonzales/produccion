/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.message;

/**
 *
 * @author DASISAQ
 */
public class MensajeTransaccion {
    private String mensajeTransaccion="";
    private Boolean transaccionExitosa=false;
    /**
     * Creates a new instance of MensajeTransaccion
     */
    public MensajeTransaccion() {
    }

    public String getMensajeTransaccion() {
        return mensajeTransaccion;
    }

    public void setMensajeTransaccion(String mensajeTransaccion) {
        this.mensajeTransaccion = mensajeTransaccion;
    }

    public Boolean getTransaccionExitosa() {
        return transaccionExitosa;
    }

    public void setTransaccionExitosa(Boolean transaccionExitosa) {
        this.transaccionExitosa = transaccionExitosa;
    }
    
}
