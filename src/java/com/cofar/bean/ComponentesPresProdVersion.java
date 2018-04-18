/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.bean;

import java.util.List;

/**
 *
 * @author DASISAQ
 */
public class ComponentesPresProdVersion extends ComponentesPresProd
{
    private FormulaMaestraEsVersion formulaMaestraEsVersion = new FormulaMaestraEsVersion();
    private List<FormulaMaestraDetalleES> formulaMaestraDetalleESList;

    public ComponentesPresProdVersion() {
        super();
    }

    public List<FormulaMaestraDetalleES> getFormulaMaestraDetalleESList() {
        return formulaMaestraDetalleESList;
    }

    public void setFormulaMaestraDetalleESList(List<FormulaMaestraDetalleES> formulaMaestraDetalleESList) {
        this.formulaMaestraDetalleESList = formulaMaestraDetalleESList;
    }
    public int getFormulaMaestraDetalleESListSize()
    {
        return (this.formulaMaestraDetalleESList!=null?formulaMaestraDetalleESList.size():0);
    }

    public FormulaMaestraEsVersion getFormulaMaestraEsVersion() {
        return formulaMaestraEsVersion;
    }

    public void setFormulaMaestraEsVersion(FormulaMaestraEsVersion formulaMaestraEsVersion) {
        this.formulaMaestraEsVersion = formulaMaestraEsVersion;
    }
    
    
    
    
}
