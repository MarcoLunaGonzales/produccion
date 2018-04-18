/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author aquispe
 */
public class MaterialesCompuestosCc extends AbstractBean{
    private int codMaterialCompuestoCc=0;
    private String nombreMaterialCompuestoCc="";
    private Materiales material1=new Materiales();
    private Materiales material2=new Materiales();
    private Double porcientoResultadoMaterial1=0d;
    private Double porcientoResultadoMaterial2=0d;

    public MaterialesCompuestosCc() {
    }

    public int getCodMaterialCompuestoCc() {
        return codMaterialCompuestoCc;
    }

    public void setCodMaterialCompuestoCc(int codMaterialCompuestoCc) {
        this.codMaterialCompuestoCc = codMaterialCompuestoCc;
    }

    public Materiales getMaterial1() {
        return material1;
    }

    public void setMaterial1(Materiales material1) {
        this.material1 = material1;
    }

    public Materiales getMaterial2() {
        return material2;
    }

    public void setMaterial2(Materiales material2) {
        this.material2 = material2;
    }

    public String getNombreMaterialCompuestoCc() {
        return nombreMaterialCompuestoCc;
    }

    public void setNombreMaterialCompuestoCc(String nombreMaterialCompuestoCc) {
        this.nombreMaterialCompuestoCc = nombreMaterialCompuestoCc;
    }

    public Double getPorcientoResultadoMaterial1() {
        return porcientoResultadoMaterial1;
    }

    public void setPorcientoResultadoMaterial1(Double porcientoResultadoMaterial1) {
        this.porcientoResultadoMaterial1 = porcientoResultadoMaterial1;
    }

    public Double getPorcientoResultadoMaterial2() {
        return porcientoResultadoMaterial2;
    }

    public void setPorcientoResultadoMaterial2(Double porcientoResultadoMaterial2) {
        this.porcientoResultadoMaterial2 = porcientoResultadoMaterial2;
    }
    

}
