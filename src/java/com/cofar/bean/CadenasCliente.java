/*
 * CadenasClientes.java
 *h
 * Created on 14 de marzo de 2008, 18:23
 */

package com.cofar.bean;

/**
 * @author Gabriela Quelali
 * @company COFAR
 */
public class CadenasCliente extends AbstractBean{
    
    /** Creates a new instance of CadenasClientes */
    private String codCadenaCliente="";
    private String nombreCadenaCliente="";
    private String obsCadenacliente="";
    private EstadoReferencial estadoRegistro=new EstadoReferencial();     
    public CadenasCliente() {
    }

    public String getCodCadenaCliente() {
        return codCadenaCliente;
    }

    public void setCodCadenaCliente(String codCadenaCliente) {
        this.codCadenaCliente = codCadenaCliente;
    }

    public String getNombreCadenaCliente() {
        return nombreCadenaCliente;
    }

    public void setNombreCadenaCliente(String nombreCadenaCliente) {
        this.nombreCadenaCliente = nombreCadenaCliente;
    }

    public String getObsCadenacliente() {
        return obsCadenacliente;
    }

    public void setObsCadenacliente(String obsCadenacliente) {
        this.obsCadenacliente = obsCadenacliente;
    }

    public EstadoReferencial getEstadoRegistro() {
        return estadoRegistro;
    }

    public void setEstadoRegistro(EstadoReferencial estadoRegistro) {
        this.estadoRegistro = estadoRegistro;
    }

    
}
