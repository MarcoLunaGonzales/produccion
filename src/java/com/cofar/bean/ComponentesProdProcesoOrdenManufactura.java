/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.bean;

/**
 *
 * @author DASISAQ-
 */
public class ComponentesProdProcesoOrdenManufactura extends AbstractBean
{
 
    private FormasFarmaceuticasProcesoOrdenManufactura formasFarmaceuticasProcesoOrdenManufactura=new FormasFarmaceuticasProcesoOrdenManufactura();
    private int orden=0;
    
    public ComponentesProdProcesoOrdenManufactura() {
    }

    
    public int getOrden() {
        return orden;
    }

    public void setOrden(int orden) {
        this.orden = orden;
    }

    public FormasFarmaceuticasProcesoOrdenManufactura getFormasFarmaceuticasProcesoOrdenManufactura() {
        return formasFarmaceuticasProcesoOrdenManufactura;
    }

    public void setFormasFarmaceuticasProcesoOrdenManufactura(FormasFarmaceuticasProcesoOrdenManufactura formasFarmaceuticasProcesoOrdenManufactura) {
        this.formasFarmaceuticasProcesoOrdenManufactura = formasFarmaceuticasProcesoOrdenManufactura;
    }

   
   
}
