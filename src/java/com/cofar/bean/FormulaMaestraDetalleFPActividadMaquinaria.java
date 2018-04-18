/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author hvaldivia
 */
public class FormulaMaestraDetalleFPActividadMaquinaria extends AbstractBean {
    int codFaseMaquinaria = 0;
    FormulaMaestraDetalleFPActividad formulaMaestraFaseActividad = new FormulaMaestraDetalleFPActividad();
    Maquinaria maquinaria = new Maquinaria();
    float caudalMaquinaria = 0;
    UnidadesVelocidadMaquinaria unidadesCaudalMaquinaria = new UnidadesVelocidadMaquinaria();
    float velocidadMaquinaria =0;
    UnidadesVelocidadMaquinaria unidadesVelocidadMaquinaria = new UnidadesVelocidadMaquinaria();
    float TiempoMaquinaria = 0;
    

    public float getTiempoMaquinaria() {
        return TiempoMaquinaria;
    }

    public void setTiempoMaquinaria(float TiempoMaquinaria) {
        this.TiempoMaquinaria = TiempoMaquinaria;
    }

    public float getCaudalMaquinaria() {
        return caudalMaquinaria;
    }

    public void setCaudalMaquinaria(float caudalMaquinaria) {
        this.caudalMaquinaria = caudalMaquinaria;
    }

    public int getCodFaseMaquinaria() {
        return codFaseMaquinaria;
    }

    public void setCodFaseMaquinaria(int codFaseMaquinaria) {
        this.codFaseMaquinaria = codFaseMaquinaria;
    }

    public FormulaMaestraDetalleFPActividad getFormulaMaestraFaseActividad() {
        return formulaMaestraFaseActividad;
    }

    public void setFormulaMaestraFaseActividad(FormulaMaestraDetalleFPActividad formulaMaestraFaseActividad) {
        this.formulaMaestraFaseActividad = formulaMaestraFaseActividad;
    }

    public Maquinaria getMaquinaria() {
        return maquinaria;
    }

    public void setMaquinaria(Maquinaria maquinaria) {
        this.maquinaria = maquinaria;
    }

    public UnidadesVelocidadMaquinaria getUnidadesCaudalMaquinaria() {
        return unidadesCaudalMaquinaria;
    }

    public void setUnidadesCaudalMaquinaria(UnidadesVelocidadMaquinaria unidadesCaudalMaquinaria) {
        this.unidadesCaudalMaquinaria = unidadesCaudalMaquinaria;
    }

    public UnidadesVelocidadMaquinaria getUnidadesVelocidadMaquinaria() {
        return unidadesVelocidadMaquinaria;
    }

    public void setUnidadesVelocidadMaquinaria(UnidadesVelocidadMaquinaria unidadesVelocidadMaquinaria) {
        this.unidadesVelocidadMaquinaria = unidadesVelocidadMaquinaria;
    }

    public float getVelocidadMaquinaria() {
        return velocidadMaquinaria;
    }

    public void setVelocidadMaquinaria(float velocidadMaquinaria) {
        this.velocidadMaquinaria = velocidadMaquinaria;
    }

}
