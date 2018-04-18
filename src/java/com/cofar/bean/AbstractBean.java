/*
 * AbstractBean.java
 *
 * Created on 14 de marzo de 2008, 18:24
 */

package com.cofar.bean;


/**
 *
 * @author Wilmer Manzaneda chavez
 * @company COFAR
 */
public class AbstractBean 
{
    
    /** Creates a new instance of AbstractBean */
    private Boolean checked=new Boolean (false);
    private String colorFila = "";
    private String descr = "";
    //campo utilizado para la cantidad de versiones a las que se encuentra enlazado una version
    private int cantidadVersiones=0;
    //campo para cantida de datos relacionados
    private int cantidadDatosRelacionados=0;
    public AbstractBean() {
    }

    public Boolean getChecked() {
        return checked;
    }

    public void setChecked(Boolean checked) {
        this.checked = checked;
    }

    public String getColorFila() {
        return colorFila;
    }

    public void setColorFila(String colorFila) {
        this.colorFila = colorFila;
    }

    public String getDescr() {
        return descr;
    }

    public void setDescr(String descr) {
        this.descr = descr;
    }

    public int getCantidadVersiones() {
        return cantidadVersiones;
    }

    public void setCantidadVersiones(int cantidadVersiones) {
        this.cantidadVersiones = cantidadVersiones;
    }

    public int getCantidadDatosRelacionados() {
        return cantidadDatosRelacionados;
    }

    public void setCantidadDatosRelacionados(int cantidadDatosRelacionados) {
        this.cantidadDatosRelacionados = cantidadDatosRelacionados;
    }

    


    
    


}
