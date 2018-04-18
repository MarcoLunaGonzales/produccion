/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author aquispe
 */
public class DefectosEnvaseProgramaProduccion extends AbstractBean{

    private DefectosEnvase defectoEnvase=new DefectosEnvase();
    private List<DefectosEnvasePersonal> defectosEnvasePersonalList=new ArrayList<DefectosEnvasePersonal>();

    public DefectosEnvaseProgramaProduccion() {
    }

    public DefectosEnvase getDefectoEnvase() {
        return defectoEnvase;
    }

    public void setDefectoEnvase(DefectosEnvase defectoEnvase) {
        this.defectoEnvase = defectoEnvase;
    }

    public List<DefectosEnvasePersonal> getDefectosEnvasePersonalList() {
        return defectosEnvasePersonalList;
    }

    public void setDefectosEnvasePersonalList(List<DefectosEnvasePersonal> defectosEnvasePersonalList) {
        this.defectosEnvasePersonalList = defectosEnvasePersonalList;
    }
    
    

}
