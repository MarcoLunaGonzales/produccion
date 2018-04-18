/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.web;

import com.cofar.bean.ProgramaProduccionDevolucionMaterial;
import com.cofar.bean.ProgramaProduccionDevolucionMaterialDetalle;
import com.cofar.util.Util;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author wchoquehuanca
 */

public class ManagedProgramaProducionDevolucionMaterial extends ManagedBean{

    private Connection con=null;
    private List<ProgramaProduccionDevolucionMaterial> programaProduccionDevolucionMaterialList= new ArrayList<ProgramaProduccionDevolucionMaterial>();
    private String mensaje="";
    private ProgramaProduccionDevolucionMaterial currentProgProdDevMaterial= new ProgramaProduccionDevolucionMaterial();
    private List<ProgramaProduccionDevolucionMaterialDetalle> programaProdDevMatListRechazados= new ArrayList<ProgramaProduccionDevolucionMaterialDetalle>();
    private ProgramaProduccionDevolucionMaterial currentProgProdDevEditar= new ProgramaProduccionDevolucionMaterial();
    private List<ProgramaProduccionDevolucionMaterialDetalle> programaProdDevMatListEditar= new ArrayList<ProgramaProduccionDevolucionMaterialDetalle>();

    /** Creates a new instance of ManagedProgramaProducionDevolucionMaterial */
    public ManagedProgramaProducionDevolucionMaterial() {
    }
    public String getCargarProgramaProduccionDevolucionMaterial()
    {
        //componentesProdList = this.listaComponentesProd();
        try
        {
            String consulta="select ppdm.FECHA_REGISTRO,ppdm.COD_PROGRAMA_PRODUCCION_DEVOLUCION_MATERIAL,ppdm.COD_ESTADO_PROGRAMA_PRODUCCION_DEVOLUCION,eppd.NOMBRE_ESTADO_PROGRAMA_PRODUCCION_DEVOLUCION," +
                            " ppdm.COD_PROGRAMA_PROD,cp.nombre_prod_semiterminado,ppdm.COD_LOTE_PRODUCCION,ppdm.COD_COMPPROD,ppdm.COD_TIPO_PROGRAMA_PROD," +
                            " tpp.NOMBRE_TIPO_PROGRAMA_PROD,ae.NOMBRE_AREA_EMPRESA,ida.CANT_TOTAL_INGRESO,ppdm.COD_FORMULA_MAESTRA"+
                            " from PROGRAMA_PRODUCCION_DEVOLUCION_MATERIAL ppdm inner join TIPOS_PROGRAMA_PRODUCCION tpp"+
                            " on tpp.COD_TIPO_PROGRAMA_PROD=ppdm.COD_TIPO_PROGRAMA_PROD inner join COMPONENTES_PROD cp "+
                            " on cp.COD_COMPPROD=ppdm.COD_COMPPROD inner join AREAS_EMPRESA ae on ae.COD_AREA_EMPRESA=cp.COD_AREA_EMPRESA"+
                            " inner join PROGRAMA_PRODUCCION_INGRESOS_ACOND ppia on "+
                            " ppia.COD_COMPPROD=ppdm.COD_COMPPROD and ppia.COD_FORMULA_MAESTRA=ppdm.COD_FORMULA_MAESTRA"+
                            " and ppia.COD_LOTE_PRODUCCION=ppdm.COD_LOTE_PRODUCCION and ppia.COD_PROGRAMA_PROD=ppdm.COD_PROGRAMA_PROD"+
                            " and ppia.COD_TIPO_PROGRAMA_PROD=ppdm.COD_TIPO_PROGRAMA_PROD and ppia.COD_TIPO_ENTREGA_ACOND=2"+
                            " inner join INGRESOS_ACOND ia on ia.COD_INGRESO_ACOND=ppia.COD_INGRESO_ACOND "+
                            " inner join INGRESOS_DETALLEACOND ida on ia.COD_INGRESO_ACOND=ida.COD_INGRESO_ACOND and ida.COD_COMPPROD=ppdm.COD_COMPPROD" +
                            " inner join ESTADOS_PROGRAMA_PRODUCCION_DEVOLUCION eppd on eppd.COD_ESTADO_PROGRAMA_PRODUCCION_DEVOLUCION=ppdm.COD_ESTADO_PROGRAMA_PRODUCCION_DEVOLUCION" +
                            " group by  ppdm.FECHA_REGISTRO,ppdm.COD_PROGRAMA_PRODUCCION_DEVOLUCION_MATERIAL,ppdm.COD_ESTADO_PROGRAMA_PRODUCCION_DEVOLUCION,eppd.NOMBRE_ESTADO_PROGRAMA_PRODUCCION_DEVOLUCION," +
                            " ppdm.COD_PROGRAMA_PROD,cp.nombre_prod_semiterminado,ppdm.COD_LOTE_PRODUCCION,ppdm.COD_COMPPROD,ppdm.COD_TIPO_PROGRAMA_PROD," +
                            " tpp.NOMBRE_TIPO_PROGRAMA_PROD,ae.NOMBRE_AREA_EMPRESA,ida.CANT_TOTAL_INGRESO,ppdm.COD_FORMULA_MAESTRA" +
                            " order by ppdm.FECHA_REGISTRO desc,cp.nombre_prod_semiterminado asc ";
            System.out.println("consulta cargar "+consulta);

            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta);
            programaProduccionDevolucionMaterialList.clear();
            while(res.next())
            {
                ProgramaProduccionDevolucionMaterial bean= new ProgramaProduccionDevolucionMaterial();
                bean.getProgramaProduccion().getFormulaMaestra().setCodFormulaMaestra(res.getString("COD_FORMULA_MAESTRA"));
                bean.getProgramaProduccion().getFormulaMaestra().getComponentesProd().setCodCompprod(res.getString("COD_COMPPROD"));
                bean.getProgramaProduccion().getFormulaMaestra().getComponentesProd().setNombreProdSemiterminado(res.getString("nombre_prod_semiterminado"));
                bean.getProgramaProduccion().setCodLoteProduccion(res.getString("COD_LOTE_PRODUCCION"));
                bean.getProgramaProduccion().getTiposProgramaProduccion().setCodTipoProgramaProd(res.getString("COD_TIPO_PROGRAMA_PROD"));
                bean.getProgramaProduccion().getTiposProgramaProduccion().setNombreProgramaProd(res.getString("NOMBRE_TIPO_PROGRAMA_PROD"));
                bean.getProgramaProduccion().getFormulaMaestra().getComponentesProd().getAreasEmpresa().setNombreAreaEmpresa(res.getString("NOMBRE_AREA_EMPRESA"));
                bean.getProgramaProduccion().setCantidadLote(res.getDouble("CANT_TOTAL_INGRESO"));
                bean.getProgramaProduccion().setCodProgramaProduccion(res.getString("COD_PROGRAMA_PROD"));
                bean.getEstadoDevolucionMaterial().setCodEstadoRegistro(res.getString("COD_ESTADO_PROGRAMA_PRODUCCION_DEVOLUCION"));
                bean.getEstadoDevolucionMaterial().setNombreEstadoRegistro(res.getString("NOMBRE_ESTADO_PROGRAMA_PRODUCCION_DEVOLUCION"));
                bean.setCodProgramaProduccionDevolucionMaterial(res.getString("COD_PROGRAMA_PRODUCCION_DEVOLUCION_MATERIAL"));
                bean.setFechaRegistro(res.getTimestamp("FECHA_REGISTRO"));
                programaProduccionDevolucionMaterialList.add(bean);
            }
            res.close();
            st.close();
            con.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
        return null;
    }
    public String guardarCambiosEdicion()
    {
        try
        {
            Connection con=null;
            con=Util.openConnection(con);
            String consulta="DELETE PROGRAMA_PRODUCCION_DEVOLUCION_MATERIAL_DETALLE  where COD_PROGRAMA_PRODUCCION_DEVOLUCION_MATERIAL='"+currentProgProdDevEditar.getCodProgramaProduccionDevolucionMaterial()+"'";
            System.out.println("consulta delete "+consulta);
            PreparedStatement pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se eliminaron los detalles de la tabal programa produccion devolucion material detalle");
            for(ProgramaProduccionDevolucionMaterialDetalle current:programaProdDevMatListEditar)
            {
                if(current.getChecked())
                {
                    consulta="INSERT INTO PROGRAMA_PRODUCCION_DEVOLUCION_MATERIAL_DETALLE(COD_PROGRAMA_PRODUCCION_DEVOLUCION_MATERIAL, COD_MATERIAL, CANTIDAD_BUENOS,"+
                            " CANTIDAD_BUENOS_ENTREGADOS, CANTIDAD_MALOS, CANTIDAD_MALOS_ENTREGADOS,OBSERVACION)"+
                            " VALUES ('"+currentProgProdDevEditar.getCodProgramaProduccionDevolucionMaterial()+"','"+current.getMateriales().getCodMaterial() +"','"+current.getCantidadBuenos()+"',0,'"+current.getCantidadMalos()+"',"+
                            "0,'"+current.getObservacion()+"')";
                    System.out.println("consulta insertar "+consulta);

                    pst=con.prepareStatement(consulta);
                    if(pst.executeUpdate()>0)System.out.println("se actualizo la cantidad de la devolución");

                }
            }
            pst.close();
            con.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
        return this.getCargarProgramaProduccionDevolucionMaterial();
    }
    public String rehacerDevolucionMaterial()
    {
        setMensaje("");
        for(ProgramaProduccionDevolucionMaterial bean: programaProduccionDevolucionMaterialList)
        {
            if(bean.getChecked())
            {
                currentProgProdDevMaterial=bean;
                break;
            }

        }

        if(Integer.valueOf(currentProgProdDevMaterial.getEstadoDevolucionMaterial().getCodEstadoRegistro())!=4)
        {
            mensaje="No se puede rehacer un registro generado";
            return null;
        }
        programaProdDevMatListRechazados=this.cargarDevolucionesMaterialEditar(currentProgProdDevMaterial);
        return null;
    }

    private List<ProgramaProduccionDevolucionMaterialDetalle> cargarDevolucionesMaterialEditar(ProgramaProduccionDevolucionMaterial bean)
    {
        List<ProgramaProduccionDevolucionMaterialDetalle> nuevaLista=new ArrayList<ProgramaProduccionDevolucionMaterialDetalle>();
        try
        {
            Connection con2=null;
            con2=Util.openConnection(con2);
            String consulta="select m.COD_MATERIAL,m.NOMBRE_MATERIAL,fmd.CANTIDAD,ISNULL(ppdmd.CANTIDAD_BUENOS, 0) as cantidadBuenos," +
                            " ISNULL(ppdmd.CANTIDAD_MALOS, 0) as cantidadMalos,ISNULL(ppdmd.OBSERVACION,'') as observacion,um.ABREVIATURA"+
                            " from  MATERIALES m inner join FORMULA_MAESTRA_DETALLE_EP fmd on m.COD_MATERIAL=fmd.COD_MATERIAL "+
                            " INNER JOIN  PRESENTACIONES_PRIMARIAS PP ON PP.COD_PRESENTACION_PRIMARIA=fmd.COD_PRESENTACION_PRIMARIA "+
                            " inner join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=fmd.COD_UNIDAD_MEDIDA inner join FORMULA_MAESTRA fm on fm.COD_FORMULA_MAESTRA=fmd.COD_FORMULA_MAESTRA and fm.COD_ESTADO_REGISTRO=1"+
                            " left outer join PROGRAMA_PRODUCCION_DEVOLUCION_MATERIAL_DETALLE ppdmd on "+
                            " ppdmd.COD_MATERIAL=m.COD_MATERIAL and ppdmd.COD_PROGRAMA_PRODUCCION_DEVOLUCION_MATERIAL='"+bean.getCodProgramaProduccionDevolucionMaterial()+"'"+
                            " where fmd.COD_FORMULA_MAESTRA='"+bean.getProgramaProduccion().getFormulaMaestra().getCodFormulaMaestra()+"'"+
                            " and pp.COD_TIPO_PROGRAMA_PROD='"+bean.getProgramaProduccion().getTiposProgramaProduccion().getCodTipoProgramaProd()+"'"+
                            " and fm.COD_COMPPROD='"+bean.getProgramaProduccion().getFormulaMaestra().getComponentesProd().getCodCompprod()+"' order by m.COD_MATERIAL";

            System.out.println("consulta cargar detalle"+consulta);
            Statement st=con2.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta);
            nuevaLista.clear();
            while(res.next())
            {
                ProgramaProduccionDevolucionMaterialDetalle newDev= new ProgramaProduccionDevolucionMaterialDetalle();

                newDev.getProgramaProduccionDevolucionMaterial().setCodProgramaProduccionDevolucionMaterial(bean.getCodProgramaProduccionDevolucionMaterial());
                newDev.getProgramaProduccionDevolucionMaterial().getProgramaProduccion().getFormulaMaestra().setCantidadLote(res.getDouble("CANTIDAD"));
                newDev.getMateriales().setCodMaterial(res.getString("COD_MATERIAL"));
                newDev.getMateriales().setNombreMaterial(res.getString("NOMBRE_MATERIAL"));
                newDev.setCantidadBuenos(res.getDouble("cantidadBuenos"));
                newDev.setCantidadMalos(res.getDouble("cantidadMalos"));
                newDev.getMateriales().getUnidadesMedida().setAbreviatura(res.getString("ABREVIATURA"));
                newDev.setObservacion(res.getString("observacion"));
                if(newDev.getCantidadBuenos()>0||newDev.getCantidadMalos()>0)
                    newDev.setChecked(true);
                nuevaLista.add(newDev);
            }
            res.close();
            st.close();
            con2.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
        return nuevaLista;
    }

    public String guardarCambioDeDatosRechazados()
    {
        try
        {
            String consulta="select ISNULL(MAX(ppdm.COD_PROGRAMA_PRODUCCION_DEVOLUCION_MATERIAL),0)+1 as codProgProd from PROGRAMA_PRODUCCION_DEVOLUCION_MATERIAL ppdm ";
            int cont=0;
            Connection con1=null;
            con1=Util.openConnection(con1);
            Statement st=con1.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta);
            if(res.next())
            {
                cont=res.getInt("codProgProd");
            }
            SimpleDateFormat sdt= new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
            consulta="INSERT INTO PROGRAMA_PRODUCCION_DEVOLUCION_MATERIAL(COD_PROGRAMA_PROD,COD_COMPPROD,COD_FORMULA_MAESTRA,"+
                     " COD_LOTE_PRODUCCION,COD_TIPO_PROGRAMA_PROD,COD_ESTADO_PROGRAMA_PRODUCCION_DEVOLUCION,COD_PROGRAMA_PRODUCCION_DEVOLUCION_MATERIAL"+
                     ",FECHA_REGISTRO )VALUES ('"+currentProgProdDevMaterial.getProgramaProduccion().getCodProgramaProduccion()+"',"+
                     "'"+currentProgProdDevMaterial.getProgramaProduccion().getFormulaMaestra().getComponentesProd().getCodCompprod()+"',"+
                     "'"+currentProgProdDevMaterial.getProgramaProduccion().getFormulaMaestra().getCodFormulaMaestra()+"',"+
                     "'"+currentProgProdDevMaterial.getProgramaProduccion().getCodLoteProduccion()+"',"+
                     "'"+currentProgProdDevMaterial.getProgramaProduccion().getTiposProgramaProduccion().getCodTipoProgramaProd()+"',"+
                     "1,'"+cont+"','"+sdt.format(currentProgProdDevMaterial.getFechaRegistro())+"')";
            System.out.println("consulta insert cabecera "+consulta);
            PreparedStatement pst=con1.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se rehizo la devolucion");
            pst.close();
            for(ProgramaProduccionDevolucionMaterialDetalle current:programaProdDevMatListRechazados)
            {
                if(current.getChecked())
                {
                    consulta="INSERT INTO PROGRAMA_PRODUCCION_DEVOLUCION_MATERIAL_DETALLE(COD_PROGRAMA_PRODUCCION_DEVOLUCION_MATERIAL, COD_MATERIAL, CANTIDAD_BUENOS,"+
                            " CANTIDAD_BUENOS_ENTREGADOS, CANTIDAD_MALOS, CANTIDAD_MALOS_ENTREGADOS,OBSERVACION)"+
                            " VALUES ('"+cont+"','"+current.getMateriales().getCodMaterial() +"','"+current.getCantidadBuenos()+"',0,'"+current.getCantidadMalos()+"',"+
                            "0,'"+current.getObservacion()+"')";
                    System.out.println("consulta insert "+consulta);
                    pst=con1.prepareStatement(consulta);
                    if(pst.executeUpdate()>0)System.out.println("Se rehizo el detalle de la devolución");
                    pst.close();
                }
            }
            res.close();
            st.close();
            con1.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
        return this.getCargarProgramaProduccionDevolucionMaterial();
    }
    public String editarDevolucionMaterial()
    {
        setMensaje("");
        for(ProgramaProduccionDevolucionMaterial current:programaProduccionDevolucionMaterialList)
        {
            if(current.getChecked())
            {
                currentProgProdDevEditar=current;
            }
        }

        if(Integer.valueOf(currentProgProdDevEditar.getEstadoDevolucionMaterial().getCodEstadoRegistro())!=1)
        {
            mensaje="No se puede editar un registro que ha sido rechazado";
            return null;
        }
        else
        {
            programaProdDevMatListEditar=this.cargarDevolucionesMaterialEditar(currentProgProdDevEditar);

        }

        return null;
    }
    public List<ProgramaProduccionDevolucionMaterial> getProgramaProduccionDevolucionMaterialList() {
        return programaProduccionDevolucionMaterialList;
    }

    public void setProgramaProduccionDevolucionMaterialList(List<ProgramaProduccionDevolucionMaterial> programaProduccionDevolucionMaterialList) {
        this.programaProduccionDevolucionMaterialList = programaProduccionDevolucionMaterialList;
    }

    public String getMensaje() {
        return mensaje;
    }

    public void setMensaje(String mensaje) {
        this.mensaje = mensaje;
    }



    public ProgramaProduccionDevolucionMaterial getCurrentProgProdDevEditar() {
        return currentProgProdDevEditar;
    }

    public void setCurrentProgProdDevEditar(ProgramaProduccionDevolucionMaterial currentProgProdDevEditar) {
        this.currentProgProdDevEditar = currentProgProdDevEditar;
    }

    public ProgramaProduccionDevolucionMaterial getCurrentProgProdDevMaterial() {
        return currentProgProdDevMaterial;
    }

    public void setCurrentProgProdDevMaterial(ProgramaProduccionDevolucionMaterial currentProgProdDevMaterial) {
        this.currentProgProdDevMaterial = currentProgProdDevMaterial;
    }

    public List<ProgramaProduccionDevolucionMaterialDetalle> getProgramaProdDevMatListEditar() {
        return programaProdDevMatListEditar;
    }

    public void setProgramaProdDevMatListEditar(List<ProgramaProduccionDevolucionMaterialDetalle> programaProdDevMatListEditar) {
        this.programaProdDevMatListEditar = programaProdDevMatListEditar;
    }

    public List<ProgramaProduccionDevolucionMaterialDetalle> getProgramaProdDevMatListRechazados() {
        return programaProdDevMatListRechazados;
    }

    public void setProgramaProdDevMatListRechazados(List<ProgramaProduccionDevolucionMaterialDetalle> programaProdDevMatListRechazados) {
        this.programaProdDevMatListRechazados = programaProdDevMatListRechazados;
    }




}