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
public class FormulaMaestraEP extends AbstractBean {
    
    /** Creates a new instance of ComponentesProd */
    private FormulaMaestra formulaMaestra=new FormulaMaestra();
    private PresentacionesPrimarias presentacionesPrimarias=new PresentacionesPrimarias();
    

    public FormulaMaestra getFormulaMaestra() {
        return formulaMaestra;
    }

    public void setFormulaMaestra(FormulaMaestra formulaMaestra) {
        this.formulaMaestra = formulaMaestra;
    }

    public PresentacionesPrimarias getPresentacionesPrimarias() {
        return presentacionesPrimarias;
    }

    public void setPresentacionesPrimarias(PresentacionesPrimarias presentacionesPrimarias) {
        this.presentacionesPrimarias = presentacionesPrimarias;
    }


    
    

  
}
