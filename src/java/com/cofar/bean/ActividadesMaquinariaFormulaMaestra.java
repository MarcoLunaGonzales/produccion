/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.bean;

import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author DASISAQ-
 */
public class ActividadesMaquinariaFormulaMaestra extends AbstractBean
{
    private ActividadesFormulaMaestra actividadesFormulaMaestra = new ActividadesFormulaMaestra();
        private MaquinariaActividadesFormula maquinariaActividadesFormula = new MaquinariaActividadesFormula();
        private List maquinariasList = new ArrayList();
        private Boolean checked=false;
        
        public ActividadesFormulaMaestra getActividadesFormulaMaestra() {
            return actividadesFormulaMaestra;
        }

        public void setActividadesFormulaMaestra(ActividadesFormulaMaestra actividadesFormulaMaestra) {
            this.actividadesFormulaMaestra = actividadesFormulaMaestra;
        }

        public MaquinariaActividadesFormula getMaquinariaActividadesFormula() {
            return maquinariaActividadesFormula;
        }

        public void setMaquinariaActividadesFormula(MaquinariaActividadesFormula maquinariaActividadesFormula) {
            this.maquinariaActividadesFormula = maquinariaActividadesFormula;
        }

        public List getMaquinariasList() {
            return maquinariasList;
        }

        public void setMaquinariasList(List maquinariasList) {
            this.maquinariasList = maquinariasList;
        }

        public Boolean getChecked() {
            return checked;
        }

        public void setChecked(Boolean checked) {
            this.checked = checked;
        }
}
