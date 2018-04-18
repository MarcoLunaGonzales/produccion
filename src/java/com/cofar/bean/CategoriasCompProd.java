/*
 * TipoCliente.java
 * Created on 19 de febrero de 2008, 16:53
 */

package com.cofar.bean;
/**
 *  @author Wilson Choquehuanca
 *  @company COFAR
 */
public class CategoriasCompProd extends AbstractBean {
    
    /** Creates a new instance of TipoCliente */
    private String codCategoriaCompProd="";
    private String nombreCategoriaCompProd="";
    private String obsCategoriaCompProd="";
    private EstadoReferencial estadoRegistro=new EstadoReferencial();     

    public CategoriasCompProd() {        
    }

    public String getCodCategoriaCompProd() {
        return codCategoriaCompProd;
    }

    public void setCodCategoriaCompProd(String codCategoriaCompProd) {
        this.codCategoriaCompProd = codCategoriaCompProd;
    }

    public String getNombreCategoriaCompProd() {
        return nombreCategoriaCompProd;
    }

    public void setNombreCategoriaCompProd(String nombreCategoriaCompProd) {
        this.nombreCategoriaCompProd = nombreCategoriaCompProd;
    }

    public String getObsCategoriaCompProd() {
        return obsCategoriaCompProd;
    }

    public void setObsCategoriaCompProd(String obsCategoriaCompProd) {
        this.obsCategoriaCompProd = obsCategoriaCompProd;
    }

    public EstadoReferencial getEstadoRegistro() {
        return estadoRegistro;
    }

    public void setEstadoRegistro(EstadoReferencial estadoRegistro) {
        this.estadoRegistro = estadoRegistro;
    }

}
