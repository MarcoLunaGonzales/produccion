/*
 * TipoCliente.java
 * Created on 19 de febrero de 2008, 16:53
 */

package com.cofar.bean;
/**
 *  @author Gabriela Quelali
 *  @company COFAR
 */
public class RedesCliente extends AbstractBean {
    
    /** Creates a new instance of TipoCliente */
    private String codRedCliente="";
    private String nombreRedCliente="";
    private String obsRedCliente="";
    private EstadoReferencial estadoRegistro=new EstadoReferencial();     

    public RedesCliente() {        
    }

    public String getCodRedCliente() {
        return codRedCliente;
    }

    public void setCodRedCliente(String codRedCliente) {
        this.codRedCliente = codRedCliente;
    }

    public String getNombreRedCliente() {
        return nombreRedCliente;
    }

    public void setNombreRedCliente(String nombreRedCliente) {
        this.nombreRedCliente = nombreRedCliente;
    }

    public String getObsRedCliente() {
        return obsRedCliente;
    }

    public void setObsRedCliente(String obsRedCliente) {
        this.obsRedCliente = obsRedCliente;
    }

    public EstadoReferencial getEstadoRegistro() {
        return estadoRegistro;
    }

    public void setEstadoRegistro(EstadoReferencial estadoRegistro) {
        this.estadoRegistro = estadoRegistro;
    }

 
}
