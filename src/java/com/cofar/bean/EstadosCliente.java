/*
 * TipoCliente.java
 * Created on 19 de febrero de 2008, 16:53
 */

package com.cofar.bean;

/**
 *
 *  @author Gabriela Quelali
 *  @company COFAR
 */
public class EstadosCliente  extends AbstractBean{
    
    /** Creates a new instance of EstadoCliente */
    private String codEstadoCliente="";
    private String nombreEstadoCliente="";
    private String obsEstadoCliente="";
    private EstadoReferencial estadoRegistro=new EstadoReferencial();     

    
    
    public EstadosCliente() {
    }

    public String getCodEstadoCliente() {
        return codEstadoCliente;
    }

    public void setCodEstadoCliente(String codEstadoCliente) {
        this.codEstadoCliente = codEstadoCliente;
    }

    public String getNombreEstadoCliente() {
        return nombreEstadoCliente;
    }

    public void setNombreEstadoCliente(String nombreEstadoCliente) {
        this.nombreEstadoCliente = nombreEstadoCliente;
    }

    public String getObsEstadoCliente() {
        return obsEstadoCliente;
    }

    public void setObsEstadoCliente(String obsEstadoCliente) {
        this.obsEstadoCliente = obsEstadoCliente;
    }

    public EstadoReferencial getEstadoRegistro() {
        return estadoRegistro;
    }

    public void setEstadoRegistro(EstadoReferencial estadoRegistro) {
        this.estadoRegistro = estadoRegistro;
    }

   
}
