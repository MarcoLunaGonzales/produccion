/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author aquispe
 */
public class EspecificacionesTecnicasPresentacion extends AbstractBean{
    private PresentacionesProducto presentacionesProducto=new PresentacionesProducto();
    private EspecificacionesTecnicas especificacionesTecnicas=new EspecificacionesTecnicas();
    private String detalleEspecificacionTecnica="";
    private TiposCotizacionesVentas tiposCotizacionesVentas=new TiposCotizacionesVentas();

    public EspecificacionesTecnicasPresentacion() {
    }

    public String getDetalleEspecificacionTecnica() {
        return detalleEspecificacionTecnica;
    }

    public void setDetalleEspecificacionTecnica(String detalleEspecificacionTecnica) {
        this.detalleEspecificacionTecnica = detalleEspecificacionTecnica;
    }

    public EspecificacionesTecnicas getEspecificacionesTecnicas() {
        return especificacionesTecnicas;
    }

    public void setEspecificacionesTecnicas(EspecificacionesTecnicas especificacionesTecnicas) {
        this.especificacionesTecnicas = especificacionesTecnicas;
    }

    public PresentacionesProducto getPresentacionesProducto() {
        return presentacionesProducto;
    }

    public void setPresentacionesProducto(PresentacionesProducto presentacionesProducto) {
        this.presentacionesProducto = presentacionesProducto;
    }

    public TiposCotizacionesVentas getTiposCotizacionesVentas() {
        return tiposCotizacionesVentas;
    }

    public void setTiposCotizacionesVentas(TiposCotizacionesVentas tiposCotizacionesVentas) {
        this.tiposCotizacionesVentas = tiposCotizacionesVentas;
    }
    

}
