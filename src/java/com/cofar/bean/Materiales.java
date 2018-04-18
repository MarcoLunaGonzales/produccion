/*
 * ComponentesProd.java
 *
 * Created on 25 de mayo de 2008, 19:26
 */

package com.cofar.bean;

import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Wilson Choquehuanca Gonzales
 * @company COFAR
 */
public class Materiales extends AbstractBean {
    
    /** Creates a new instance of ComponentesProd */
    private String codMaterial="";
    private String nombreMaterial="";
    private String nombreComercialMaterial="";
    private String nombreCCC="";
    private UnidadesMedida unidadesMedida=new UnidadesMedida();
    private EstadoReferencial estadoRegistro=new EstadoReferencial();
    private Grupos grupo=new Grupos();
    private MaterialesGenericos materialesGenericos=new MaterialesGenericos();
    public String getCodMaterial() {
        return codMaterial;
    }

    public void setCodMaterial(String codMaterial) {
        this.codMaterial = codMaterial;
    }

    public String getNombreMaterial() {
        return nombreMaterial;
    }

    public void setNombreMaterial(String nombreMaterial) {
        this.nombreMaterial = nombreMaterial;
    }

    public UnidadesMedida getUnidadesMedida() {
        return unidadesMedida;
    }

    public void setUnidadesMedida(UnidadesMedida unidadesMedida) {
        this.unidadesMedida = unidadesMedida;
    }

    public EstadoReferencial getEstadoRegistro() {
        return estadoRegistro;
    }

    public void setEstadoRegistro(EstadoReferencial estadoRegistro) {
        this.estadoRegistro = estadoRegistro;
    }

    public Grupos getGrupo() {
        return grupo;
    }

    public void setGrupo(Grupos grupo) {
        this.grupo = grupo;
    }

    public String getNombreCCC() {
        return nombreCCC;
    }

    public void setNombreCCC(String nombreCCC) {
        this.nombreCCC = nombreCCC;
    }

    public String getNombreComercialMaterial() {
        return nombreComercialMaterial;
    }

    public void setNombreComercialMaterial(String nombreComercialMaterial) {
        this.nombreComercialMaterial = nombreComercialMaterial;
    }

    public MaterialesGenericos getMaterialesGenericos() {
        return materialesGenericos;
    }

    public void setMaterialesGenericos(MaterialesGenericos materialesGenericos) {
        this.materialesGenericos = materialesGenericos;
    }

    

}
