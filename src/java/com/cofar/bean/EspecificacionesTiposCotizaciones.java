/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author aquispe
 */
public class EspecificacionesTiposCotizaciones extends AbstractBean{
    private EspecificacionesTecnicas especificacionesTecnicas=new EspecificacionesTecnicas();
    private TiposCotizacionesVentas tiposCotizacionesVentas=new TiposCotizacionesVentas();

    public EspecificacionesTiposCotizaciones() {
    }

    public EspecificacionesTecnicas getEspecificacionesTecnicas() {
        return especificacionesTecnicas;
    }

    public void setEspecificacionesTecnicas(EspecificacionesTecnicas especificacionesTecnicas) {
        this.especificacionesTecnicas = especificacionesTecnicas;
    }

    public TiposCotizacionesVentas getTiposCotizacionesVentas() {
        return tiposCotizacionesVentas;
    }

    public void setTiposCotizacionesVentas(TiposCotizacionesVentas tiposCotizacionesVentas) {
        this.tiposCotizacionesVentas = tiposCotizacionesVentas;
    }
    

}
