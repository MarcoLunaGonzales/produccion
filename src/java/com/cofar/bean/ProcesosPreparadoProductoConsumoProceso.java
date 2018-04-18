/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.bean;

/**
 *
 * @author DASISAQ
 */
public class ProcesosPreparadoProductoConsumoProceso extends AbstractBean 
{
    private ProcesosPreparadoProducto procesosPreparadoProducto=new ProcesosPreparadoProducto();

    public ProcesosPreparadoProductoConsumoProceso() {
    }

    public ProcesosPreparadoProducto getProcesosPreparadoProducto() {
        return procesosPreparadoProducto;
    }

    public void setProcesosPreparadoProducto(ProcesosPreparadoProducto procesosPreparadoProducto) {
        this.procesosPreparadoProducto = procesosPreparadoProducto;
    }
    
    
}
