/*
 * TipoCliente.java
 * Created on 19 de febrero de 2008, 16:53
 */

package com.cofar.bean;

/**
 *  @author Gabriela Quelali
 *  @company COFAR
 */
public class TiposCliente extends AbstractBean {
    
    /** Creates a new instance of TipoCliente */
    private String codTipoCliente="";
    private String nombreTipoCliente="";
    private String obsTipoCliente="";
   private EstadoReferencial estadoRegistro=new EstadoReferencial();     
      
    public TiposCliente() {
    }

    public String getCodTipoCliente() {
        return codTipoCliente;
    }

    public void setCodTipoCliente(String codTipoCliente) {
        this.codTipoCliente = codTipoCliente;
    }

    public String getNombreTipoCliente() {
        return nombreTipoCliente;
    }

    public void setNombreTipoCliente(String nombreTipoCliente) {
        this.nombreTipoCliente = nombreTipoCliente;
    }

    public String getObsTipoCliente() {
        return obsTipoCliente;
    }

    public void setObsTipoCliente(String obsTipoCliente) {
        this.obsTipoCliente = obsTipoCliente;
    }

    public EstadoReferencial getEstadoRegistro() {
        return estadoRegistro;
    }

    public void setEstadoRegistro(EstadoReferencial estadoRegistro) {
        this.estadoRegistro = estadoRegistro;
    }

  
    
}
