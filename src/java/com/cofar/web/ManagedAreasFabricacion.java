/*
 * ManagedTipoCliente.java
 * Created on 19 de febrero de 2008, 16:50
 */

package com.cofar.web;


import com.cofar.bean.AreasFabricacion;
import com.cofar.bean.FormulaMaestraDetalleMP;
import com.cofar.bean.Materiales;
import com.cofar.bean.ProgramaProduccion;
import com.cofar.util.Util;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import javax.faces.event.ValueChangeEvent;
import javax.faces.model.SelectItem;
import org.joda.time.DateTime;
import java.text.NumberFormat;

/**
 *
 *  @author Wilmer Manzaneda Chavez
 *  @company COFAR
 */
public class ManagedAreasFabricacion {
    
    /** Creates a new instance of ManagedTipoCliente */
    private AreasFabricacion areasFabricacionbean=new AreasFabricacion();
    private List<AreasFabricacion> areasFabricacionList=new ArrayList<AreasFabricacion>();
    private List areasFabricacionEliminarList=new ArrayList();
    private List areasFabricacionNoEliminarList=new ArrayList();
    private Connection con;
    private String codigo="";
    private boolean swEliminaSi;
    private boolean swEliminaNo;
    
    
    public ManagedAreasFabricacion() {
        
        cargarAreasFabricacion();
        
    }
   /* public String getObtenerCodigo(){
        
        //String cod=Util.getParameter("codigo");
        String cod=Util.getParameter("codigo");
        String codFormula=Util.getParameter("codFormula");
        String nombre=Util.getParameter("nombre");
        String cantidad=Util.getParameter("cantidad");
        System.out.println("cxxxxxxxxxxxxxxxxxxxxxxxod:"+cod);
        if(cod!=null){
            setCodigo(cod);
        }
        if(nombre!=null){
            nombreFromulaMaestra=nombre;
        }
        if(codFormula!=null){
            setCodFormulaMaestra(codFormula);
        }
        if(cantidad!=null){
            cantidadLote=cantidad;
        }
        
        detalleProgramProd();
        
        return "";
        
    }*/
    
    public void cargarAreasFabricacion(){
        try {
            
            String sql="select ae.COD_AREA_EMPRESA,ae.NOMBRE_AREA_EMPRESA";
            sql+=" from AREAS_EMPRESA ae, AREAS_FABRICACION af";
            sql+=" where ae.COD_AREA_EMPRESA=af.COD_AREA_FABRICACION ";
            sql+=" order by ae.NOMBRE_AREA_EMPRESA";
            
            con=Util.openConnection(con);
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(sql);
            rs.last();
            int rows=rs.getRow();
            areasFabricacionList.clear();
            rs.first();
            String cod="";
            for(int i=0;i<rows;i++){
                AreasFabricacion bean=new AreasFabricacion();
                bean.getAreasEmpresa().setCodAreaEmpresa(rs.getString(1));
                bean.getAreasEmpresa().setNombreAreaEmpresa(rs.getString(2));
                areasFabricacionList.add(bean);
                rs.next();
            }
            
            if(rs!=null){
                rs.close();
                st.close();
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
  /*  public String  getCargarProgramaProduccion1(){
        try {
            String sql="select pp.cod_programa_prod,fm.cod_formula_maestra,pp.cod_lote_produccion,";
            sql+=" pp.fecha_inicio,pp.fecha_final,pp.cod_estado_programa,pp.observacion,";
            sql+=" cp.nombre_prod_semiterminado,cp.cod_compprod,fm.cantidad_lote,epp.NOMBRE_ESTADO_PROGRAMA_PROD,pp.cant_lote_produccion";
            sql+=" from programa_produccion pp,formula_maestra fm,componentes_prod cp,ESTADOS_PROGRAMA_PRODUCCION epp";
            sql+=" where pp.cod_formula_maestra=fm.cod_formula_maestra and cp.cod_compprod=fm.cod_compprod and epp.COD_ESTADO_PROGRAMA_PROD=pp.cod_estado_programa";
            sql+=" and pp.cod_estado_programa <> 4";
            sql+=" order by cp.nombre_prod_semiterminado";
            System.out.println("sql nabegador:"+sql);
            setCon(Util.openConnection(getCon()));
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(sql);
            rs.last();
            int rows=rs.getRow();
            programaProduccionList.clear();
            rs.first();
            String cod="";
            for(int i=0;i<rows;i++){
                ProgramaProduccion bean=new ProgramaProduccion();
                bean.setCodProgramaProduccion(rs.getString(1));
                bean.getFormulaMaestra().setCodFormulaMaestra(rs.getString(2));
                bean.setCodLoteProduccion(rs.getString(3));
                String fechaInicio=rs.getString(4);
                String fechaInicioVector[]=fechaInicio.split(" ");
                fechaInicioVector=fechaInicioVector[0].split("-");
                fechaInicio=fechaInicioVector[2]+"/"+fechaInicioVector[1]+"/"+fechaInicioVector[0];
                bean.setFechaInicio(fechaInicio);
                String fechaFinal=rs.getString(5);
                String fechaFinalVector[]=fechaFinal.split(" ");
                fechaFinalVector=fechaFinalVector[0].split("-");
                fechaFinal=fechaFinalVector[2]+"/"+fechaFinalVector[1]+"/"+fechaFinalVector[0];
                bean.setFechaFinal(fechaFinal);
                bean.setCodEstadoPrograma(rs.getString(6));
                bean.setObservacion(rs.getString(7));
                bean.getFormulaMaestra().getComponentesProd().setNombreProdSemiterminado(rs.getString(8));
                bean.getFormulaMaestra().getComponentesProd().setCodCompprod(rs.getString(9));
                double cantidad=rs.getDouble(10);
                cantidad=redondear(cantidad,3);
                NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
                DecimalFormat form = (DecimalFormat)nf;
                form.applyPattern("#,#00.0#");
                bean.getFormulaMaestra().setCantidadLote(form.format(cantidad));
                bean.getEstadoProgramaProduccion().setNombreEstadoProgramaProd(rs.getString(11));
                cantidad=rs.getDouble(12);
                cantidad=redondear(cantidad,3);
                bean.setCantidadLote(form.format(cantidad));
                programaProduccionList.add(bean);
                rs.next();
            }
            
            if(rs!=null){
                rs.close();
                st.close();
            }
            
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return"";
    }
    
  /*  public String actionEditar(){
        cargarEstadoRegistro("",null);
        cargarFiliales("",null);
        Iterator i=getAreasempresa().iterator();
        while (i.hasNext()){
            AreasEmpresa bean=(AreasEmpresa)i.next();
            if(bean.getChecked().booleanValue()){
                areasempresabean=bean;
                //areasempresabean.getEstadoReferencial().setCodEstadoRegistro(bean.getCodEstadoRegistro());
                break;
            }
   
        }
        return "actionEditarAreasEmpresa";
    }*/
    
    /*********actions* traer  *****/
    
    
  /*  public String actionEliminar(){
        setSwEliminaSi(false);
        setSwEliminaNo(false);
        getAreasempresaEliminar().clear();
        getAreasempresaNoEliminar().clear();
        int bandera=0;
        Iterator i=getAreasempresa().iterator();
        while (i.hasNext()){
            AreasEmpresa bean=(AreasEmpresa)i.next();
            if(bean.getChecked().booleanValue()){
                try {
                    String sql="select cod_area_empresa from cargos_en_empresa " +
                            " where cod_area_empresa="+bean.getCodAreaEmpresa();
                    setCon(Util.openConnection(getCon()));
                    Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    ResultSet rs=st.executeQuery(sql);
                    rs.last();
                    if(rs.getRow()==0){
                        bandera=1;
                    }
                    if(bandera==1){
                        sql="select cod_area_empresa from solicitudes_compra " +
                                " where cod_area_empresa="+bean.getCodAreaEmpresa();
                        setCon(Util.openConnection(getCon()));
                        st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                        rs=st.executeQuery(sql);
                        rs.last();
                        if (rs.getRow()==0){
                            bandera=1;
                        }
                    }
                    if(bandera==1){
                        sql="select cod_area_empresa from salidas_almacen " +
                                " where cod_area_empresa="+bean.getCodAreaEmpresa();
                        setCon(Util.openConnection(getCon()));
                        st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                        rs=st.executeQuery(sql);
                        rs.last();
                        if (rs.getRow()==0){
                            bandera=1;
                        }
                    }
                    if(bandera==1){
                        sql="select cod_area_empresa from areas_dependientes_inmediatas " +
                                " where cod_area_empresa="+bean.getCodAreaEmpresa();
                        setCon(Util.openConnection(getCon()));
                        st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                        rs=st.executeQuery(sql);
                        rs.last();
                        if (rs.getRow()==0){
                            bandera=1;
                        } else{
                            bandera=0;
                        }
                    }
                    if(bandera==1){
                        sql="select cod_area_empresa from personal " +
                                " where cod_area_empresa="+bean.getCodAreaEmpresa();
                        setCon(Util.openConnection(getCon()));
                        st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                        rs=st.executeQuery(sql);
                        rs.last();
                        if (rs.getRow()==0){
                            bandera=1;
                        } else{
                            bandera=0;
                        }
                    }
                    if (bandera==1){
                        getAreasempresaEliminar().add(bean);
                        setSwEliminaSi(true);
                        System.out.println("entrooooooooo eliminar");
                    }else{
                        getAreasempresaNoEliminar().add(bean);
                        setSwEliminaNo(true);
                        System.out.println("entrooooooooo no eliminar");
                    }
                    if(rs!=null){
                        rs.close();st.close();
                        rs=null;st=null;
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
        return "eliminarAreasEmpresa";
    }*/
    
    /*********actions******/
  /*  public void clearAreasEmpresa(){
        getAreasempresabean().setCodAreaEmpresa("");
        getAreasempresabean().setNombreAreaEmpresa("");
        getAreasempresabean().setObsAreaEmpresa("");
    }
   
   
   
    public String modificarAreasEmpresa(){
        try {
            setCon(Util.openConnection(getCon()));
            String  sql="update areas_empresa set";
            sql+=" cod_filial='"+getAreasempresabean().getFiliales().getCodFilial()+"',";
            sql+=" nombre_area_empresa='"+getAreasempresabean().getNombreAreaEmpresa().toUpperCase()+"',";
            sql+=" obs_area_empresa='"+getAreasempresabean().getObsAreaEmpresa()+"',";
            sql+=" cod_estado_registro='"+getAreasempresabean().getEstadoReferencial().getCodEstadoRegistro()+"'";
            sql+=" where cod_area_empresa="+getAreasempresabean().getCodAreaEmpresa();
            PreparedStatement st=getCon().prepareStatement(sql);
            int result=st.executeUpdate();
            if(result>0){
                cargarAreasEmpresa();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        clearAreasEmpresa();
        return "navegadorAreasEmpresa";
    }
    public String Cancelar(){
        areasempresa.clear();
        cargarAreasEmpresa();
        return "navegadorAreasEmpresa";
    }
   
   */
    
    /**
     * Metodo que cierra la conexion
     */
    public String getCloseConnection() throws SQLException{
        if(getCon()!=null){
            getCon().close();
        }
        return "";
    }
  /*  public String actionagregar(){
        cargarFormulaMaestra("",null);
        clearProgramaProduccion();
        return "actionAgregarProgramaProduccion";
    }*/
    
    /**********ESTADO REGISTRO****************/
  
    
  /*  public String guardarProgramaProduccion(){
        
        getCodigoPrograma();
        System.out.println("codigo:"+programaProduccionbean.getCodProgramaProduccion());
        String fechaInicio=programaProduccionbean.getFechaInicio();
        String fechaInicioVector[]=fechaInicio.split("/");
        fechaInicio=fechaInicioVector[2]+"/"+fechaInicioVector[1]+"/"+fechaInicioVector[0];
        
        String fechaFinal=programaProduccionbean.getFechaFinal();
        String fechaFinalVector[]=fechaFinal.split("/");
        fechaFinal=fechaFinalVector[2]+"/"+fechaFinalVector[1]+"/"+fechaFinalVector[0];
        try {
            String sql="insert into programa_produccion(cod_programa_prod,cod_formula_maestra,cod_lote_produccion,fecha_inicio," +
                    "fecha_final,cod_estado_programa,observacion,CANT_LOTE_PRODUCCION)values(";
            sql+=""+programaProduccionbean.getCodProgramaProduccion()+",'"+programaProduccionbean.getFormulaMaestra().getCodFormulaMaestra()+"',";
            sql+="'"+programaProduccionbean.getCodLoteProduccion()+"','"+fechaInicio+"','"+fechaFinal+"',1,'"+programaProduccionbean.getObservacion()+"','"+programaProduccionbean.getCantidadLote()+"')";
            System.out.println("insert 1:"+sql);
            setCon(Util.openConnection(getCon()));
            PreparedStatement st=getCon().prepareStatement(sql);
            int result=st.executeUpdate();
            if(result>0){
                Iterator i=formulaMaestraMPList.iterator();
                result=0;
                while (i.hasNext()){
                    FormulaMaestraDetalleMP bean=(FormulaMaestraDetalleMP)i.next();
                    if(bean.getChecked().booleanValue()){
                        String cantidad=bean.getCantidad();
                        cantidad=cantidad.replace(",","");
                        System.out.println("cantidad0:"+cantidad);
                        sql=" insert into programa_produccion_detalle(cod_programa_prod,cod_material,cod_unidad_medida,cantidad) values(";
                        sql+=""+programaProduccionbean.getCodProgramaProduccion()+",'"+bean.getMateriales().getCodMaterial()+"',";
                        sql+=""+bean.getUnidadesMedida().getCodUnidadMedida()+","+cantidad+") ";
                        System.out.println("insert detalle:sql:"+sql);
                        Statement st1=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                        result=result+st1.executeUpdate(sql);
                    }
                }
                
                Iterator j=formulaMaestraEPList.iterator();
                result=0;
                while (j.hasNext()){
                    FormulaMaestraDetalleMP bean=(FormulaMaestraDetalleMP)j.next();
                    if(bean.getChecked().booleanValue()){
                        String cantidad=bean.getCantidad();
                        cantidad=cantidad.replace(",","");
                        System.out.println("cantidad1:"+cantidad);
                        sql=" insert into programa_produccion_detalle(cod_programa_prod,cod_material,cod_unidad_medida,cantidad) values(";
                        sql+=""+programaProduccionbean.getCodProgramaProduccion()+",'"+bean.getMateriales().getCodMaterial()+"',";
                        sql+=""+bean.getUnidadesMedida().getCodUnidadMedida()+","+cantidad+") ";
                        System.out.println("insert detalle:sql:"+sql);
                        Statement st1=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                        result=result+st1.executeUpdate(sql);
                    }
                }
                
                Iterator k=formulaMaestraESList.iterator();
                result=0;
                while (k.hasNext()){
                    FormulaMaestraDetalleMP bean=(FormulaMaestraDetalleMP)k.next();
                    if(bean.getChecked().booleanValue()){
                        String cantidad=bean.getCantidad();
                        cantidad=cantidad.replace(",","");
                        System.out.println("cantidad2:"+cantidad);
                        sql=" insert into programa_produccion_detalle(cod_programa_prod,cod_material,cod_unidad_medida,cantidad) values(";
                        sql+=""+programaProduccionbean.getCodProgramaProduccion()+",'"+bean.getMateriales().getCodMaterial()+"',";
                        sql+=""+bean.getUnidadesMedida().getCodUnidadMedida()+","+cantidad+")";
                        System.out.println("insert detalle:sql:"+sql);
                        Statement st1=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                        result=result+st1.executeUpdate(sql);
                    }
                }
                
                Iterator l=formulaMaestraMPROMList.iterator();
                result=0;
                while (l.hasNext()){
                    FormulaMaestraDetalleMP bean=(FormulaMaestraDetalleMP)l.next();
                    if(bean.getChecked().booleanValue()){
                        String cantidad=bean.getCantidad();
                        cantidad=cantidad.replace(",","");
                        System.out.println("cantidad3:"+cantidad);
                        sql=" insert into programa_produccion_detalle(cod_programa_prod,cod_material,cod_unidad_medida,cantidad) values(";
                        sql+=""+programaProduccionbean.getCodProgramaProduccion()+",'"+bean.getMateriales().getCodMaterial()+"',";
                        sql+=""+bean.getUnidadesMedida().getCodUnidadMedida()+","+cantidad+") ";
                        System.out.println("insert detalle:sql:"+sql);
                        Statement st1=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                        result=result+st1.executeUpdate(sql);
                    }
                }
            }
            System.out.println("result:"+result);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        cargarProgramaProduccion();
        return "navegadorProgramaProduccion";
    }
    public void clearProgramaProduccion(){
        ProgramaProduccion x=new ProgramaProduccion();
        programaProduccionbean=x;
        formulaMaestraMPList.clear();
        formulaMaestraEPList.clear();
        formulaMaestraESList.clear();
        formulaMaestraMPROMList.clear();
    }
    
    private String codigos="";
    private String fecha_inicio="";
    private String fecha_final="";
    
    public void actionEliminar(){
        setCodigos("");
        setFecha_inicio("");
        setFecha_final("");
        for(ProgramaProduccion bean:programaProduccionList){
            if(bean.getChecked().booleanValue()){
                setCodigos(getCodigos() + (""+bean.getCodProgramaProduccion()+","));
                setFecha_inicio(getFecha_inicio() + bean.getFechaInicio() + ",");
                setFecha_final(getFecha_final() + bean.getFechaFinal() + ",");
            }
        }
        
        System.out.println("codigos:"+getCodigos());
        System.out.println("fecha_inicio:"+getFecha_inicio());
        System.out.println("fecha_final:"+getFecha_final());
        
    }
    
    
    public String actionEditar(){
        cargarFormulaMaestra("",null);
        clearProgramaProduccion();
        Iterator i=programaProduccionList.iterator();
        while (i.hasNext()){
            ProgramaProduccion bean=(ProgramaProduccion)i.next();
            if(bean.getChecked().booleanValue()){
                programaProduccionbean=bean;
                String fechaInicio=programaProduccionbean.getFechaInicio();
                System.out.println("fechaInicio:"+fechaInicio);
                String fechaInicioVector[]=fechaInicio.split("/");
                //fechaInicioVector=fechaInicioVector[0].split("-");
                fechaInicio=fechaInicioVector[0]+"/"+fechaInicioVector[1]+"/"+fechaInicioVector[2];
                programaProduccionbean.setFechaInicio(fechaInicio);
                String fechaFinal=programaProduccionbean.getFechaFinal();
                System.out.println("fechaFinal:"+fechaFinal);
                String fechaFinalVector[]=fechaFinal.split("/");
                //fechaFinalVector=fechaFinalVector[0].split("-");
                fechaFinal=fechaFinalVector[0]+"/"+fechaFinalVector[1]+"/"+fechaFinalVector[2];
                programaProduccionbean.setFechaFinal(fechaFinal);
                break;
            }
            
        }
        formulaMaestraMPList.clear();
        formulaMaestraEPList.clear();
        formulaMaestraESList.clear();
        formulaMaestraMPROMList.clear();
        try {
            String sql=" select m.cod_material,m.NOMBRE_MATERIAL,um.NOMBRE_UNIDAD_MEDIDA,mp.CANTIDAD,um.COD_UNIDAD_MEDIDA from FORMULA_MAESTRA_DETALLE_MP mp,MATERIALES m,UNIDADES_MEDIDA um" ;
            sql+=" where  m.COD_MATERIAL=mp.cod_material and um.COD_UNIDAD_MEDIDA=m.COD_UNIDAD_MEDIDA and mp.cod_formula_maestra="+programaProduccionbean.getFormulaMaestra().getCodFormulaMaestra();
            System.out.println("sql MP:"+sql);
            setCon(Util.openConnection(getCon()));
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(sql);
            while(rs.next()){
                String codMaterial=rs.getString(1);
                String nombreMaterial=rs.getString(2);
                String unidadMedida=rs.getString(3);
                String cantidad=rs.getString(4);
                String codUnidadMedida=rs.getString(5);
                FormulaMaestraDetalleMP bean=new FormulaMaestraDetalleMP();
                bean.getMateriales().setCodMaterial(codMaterial);
                bean.getMateriales().setNombreMaterial(nombreMaterial);
                bean.getUnidadesMedida().setNombreUnidadMedida(unidadMedida);
                bean.setCantidad(cantidad);
                bean.getUnidadesMedida().setCodUnidadMedida(codUnidadMedida);
                String sql_1=" select * from PROGRAMA_PRODUCCION_DETALLE pp where pp.cod_programa_prod='"+programaProduccionbean.getCodProgramaProduccion()+"' and  pp.COD_MATERIAL="+codMaterial ;
                System.out.println("sql _1:"+sql_1);
                Statement st1=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                ResultSet rs1=st1.executeQuery(sql_1);
                int sw=0;
                while(rs1.next()){
                    sw=1;
                }
                if(sw==1){
                    bean.setChecked(true);
                }else{
                    bean.setChecked(false);
                }
                formulaMaestraMPList.add(bean);
            }
            sql=" select m.cod_material,m.NOMBRE_MATERIAL,um.NOMBRE_UNIDAD_MEDIDA,mp.CANTIDAD,um.COD_UNIDAD_MEDIDA from FORMULA_MAESTRA_DETALLE_EP mp,MATERIALES m,UNIDADES_MEDIDA um" ;
            sql+=" where  m.COD_MATERIAL=mp.cod_material and um.COD_UNIDAD_MEDIDA=m.COD_UNIDAD_MEDIDA and mp.cod_formula_maestra="+programaProduccionbean.getFormulaMaestra().getCodFormulaMaestra();
            System.out.println("sql EP:"+sql);
            st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            rs=st.executeQuery(sql);
            while(rs.next()){
                String codMaterial=rs.getString(1);
                String nombreMaterial=rs.getString(2);
                String unidadMedida=rs.getString(3);
                String cantidad=rs.getString(4);
                String codUnidadMedida=rs.getString(5);
                FormulaMaestraDetalleMP bean=new FormulaMaestraDetalleMP();
                bean.getMateriales().setCodMaterial(codMaterial);
                bean.getMateriales().setNombreMaterial(nombreMaterial);
                bean.getUnidadesMedida().setNombreUnidadMedida(unidadMedida);
                bean.setCantidad(cantidad);
                bean.getUnidadesMedida().setCodUnidadMedida(codUnidadMedida);
                String sql_1=" select * from PROGRAMA_PRODUCCION_DETALLE pp where pp.cod_programa_prod='"+programaProduccionbean.getCodProgramaProduccion()+"' and pp.COD_MATERIAL="+codMaterial ;
                System.out.println("sql _1:"+sql_1);
                Statement st1=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                ResultSet rs1=st1.executeQuery(sql_1);
                int sw=0;
                while(rs1.next()){
                    sw=1;
                }
                if(sw==1){
                    bean.setChecked(true);
                }else{
                    bean.setChecked(false);
                }
                formulaMaestraEPList.add(bean);
            }
            sql=" select m.cod_material,m.NOMBRE_MATERIAL,um.NOMBRE_UNIDAD_MEDIDA,mp.CANTIDAD,um.COD_UNIDAD_MEDIDA from FORMULA_MAESTRA_DETALLE_ES mp,MATERIALES m,UNIDADES_MEDIDA um" ;
            sql+=" where  m.COD_MATERIAL=mp.cod_material and um.COD_UNIDAD_MEDIDA=m.COD_UNIDAD_MEDIDA and mp.cod_formula_maestra="+programaProduccionbean.getFormulaMaestra().getCodFormulaMaestra();
            System.out.println("sql ES:"+sql);
            st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            rs=st.executeQuery(sql);
            while(rs.next()){
                String codMaterial=rs.getString(1);
                String nombreMaterial=rs.getString(2);
                String unidadMedida=rs.getString(3);
                String cantidad=rs.getString(4);
                String codUnidadMedida=rs.getString(5);
                FormulaMaestraDetalleMP bean=new FormulaMaestraDetalleMP();
                bean.getMateriales().setCodMaterial(codMaterial);
                bean.getMateriales().setNombreMaterial(nombreMaterial);
                bean.getUnidadesMedida().setNombreUnidadMedida(unidadMedida);
                bean.setCantidad(cantidad);
                bean.getUnidadesMedida().setCodUnidadMedida(codUnidadMedida);
                String sql_1=" select * from PROGRAMA_PRODUCCION_DETALLE pp where pp.cod_programa_prod='"+programaProduccionbean.getCodProgramaProduccion()+"' and pp.COD_MATERIAL="+codMaterial ;
                System.out.println("sql _1:"+sql_1);
                Statement st1=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                ResultSet rs1=st1.executeQuery(sql_1);
                int sw=0;
                while(rs1.next()){
                    sw=1;
                }
                if(sw==1){
                    bean.setChecked(true);
                }else{
                    bean.setChecked(false);
                }
                formulaMaestraESList.add(bean);
            }
            sql=" select m.cod_material,m.NOMBRE_MATERIAL,um.NOMBRE_UNIDAD_MEDIDA,mp.CANTIDAD,um.COD_UNIDAD_MEDIDA from FORMULA_MAESTRA_DETALLE_MPROM mp,MATERIALES m,UNIDADES_MEDIDA um" ;
            sql+=" where  m.COD_MATERIAL=mp.cod_material and um.COD_UNIDAD_MEDIDA=m.COD_UNIDAD_MEDIDA and mp.cod_formula_maestra="+programaProduccionbean.getFormulaMaestra().getCodFormulaMaestra();
            System.out.println("sql MPROM:"+sql);
            st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            rs=st.executeQuery(sql);
            while(rs.next()){
                String codMaterial=rs.getString(1);
                String nombreMaterial=rs.getString(2);
                String unidadMedida=rs.getString(3);
                String cantidad=rs.getString(4);
                String codUnidadMedida=rs.getString(5);
                FormulaMaestraDetalleMP bean=new FormulaMaestraDetalleMP();
                bean.getMateriales().setCodMaterial(codMaterial);
                bean.getMateriales().setNombreMaterial(nombreMaterial);
                bean.getUnidadesMedida().setNombreUnidadMedida(unidadMedida);
                bean.setCantidad(cantidad);
                bean.getUnidadesMedida().setCodUnidadMedida(codUnidadMedida);
                String sql_1=" select * from PROGRAMA_PRODUCCION_DETALLE pp where pp.cod_programa_prod='"+programaProduccionbean.getCodProgramaProduccion()+"' and pp.COD_MATERIAL="+codMaterial ;
                System.out.println("sql _1:"+sql_1);
                Statement st1=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                ResultSet rs1=st1.executeQuery(sql_1);
                int sw=0;
                while(rs1.next()){
                    sw=1;
                }
                if(sw==1){
                    bean.setChecked(true);
                }else{
                    bean.setChecked(false);
                }
                formulaMaestraMPROMList.add(bean);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "actionEditarProgramaProduccion";
    }
    public String detalleProgramProd(){
        
        formulaMaestraMPList.clear();
        formulaMaestraEPList.clear();
        formulaMaestraESList.clear();
        formulaMaestraMPROMList.clear();
        try {
            String sql=" select m.cod_material,m.NOMBRE_MATERIAL,um.NOMBRE_UNIDAD_MEDIDA,ppd.CANTIDAD,um.COD_UNIDAD_MEDIDA from FORMULA_MAESTRA_DETALLE_MP mp,MATERIALES m,UNIDADES_MEDIDA um,PROGRAMA_PRODUCCION_DETALLE ppd" ;
            sql+=" where  m.COD_MATERIAL=mp.cod_material and um.COD_UNIDAD_MEDIDA=m.COD_UNIDAD_MEDIDA and ppd.COD_MATERIAL=m.COD_MATERIAL and mp.cod_formula_maestra="+codFormulaMaestra;
            System.out.println("sql MP:"+sql);
            setCon(Util.openConnection(getCon()));
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(sql);
            while(rs.next()){
                String codMaterial=rs.getString(1);
                String nombreMaterial=rs.getString(2);
                String unidadMedida=rs.getString(3);
                String cantidad=rs.getString(4);
                String codUnidadMedida=rs.getString(5);
                FormulaMaestraDetalleMP bean=new FormulaMaestraDetalleMP();
                bean.getMateriales().setCodMaterial(codMaterial);
                bean.getMateriales().setNombreMaterial(nombreMaterial);
                bean.getUnidadesMedida().setNombreUnidadMedida(unidadMedida);
                bean.setCantidad(cantidad);
                bean.getUnidadesMedida().setCodUnidadMedida(codUnidadMedida);
                String sql_1=" select * from PROGRAMA_PRODUCCION_DETALLE pp where pp.cod_programa_prod='"+getCodigo()+"' and  pp.COD_MATERIAL="+codMaterial ;
                System.out.println("sql _1:"+sql_1);
                Statement st1=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                ResultSet rs1=st1.executeQuery(sql_1);
                while(rs1.next()){
                    formulaMaestraMPList.add(bean);
                }
                
                
            }
            sql=" select m.cod_material,m.NOMBRE_MATERIAL,um.NOMBRE_UNIDAD_MEDIDA,ppd.CANTIDAD,um.COD_UNIDAD_MEDIDA from FORMULA_MAESTRA_DETALLE_EP mp,MATERIALES m,UNIDADES_MEDIDA um,PROGRAMA_PRODUCCION_DETALLE ppd" ;
            sql+=" where  m.COD_MATERIAL=mp.cod_material and um.COD_UNIDAD_MEDIDA=m.COD_UNIDAD_MEDIDA and ppd.COD_MATERIAL=m.COD_MATERIAL and mp.cod_formula_maestra="+codFormulaMaestra;
            System.out.println("sql EP:"+sql);
            st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            rs=st.executeQuery(sql);
            while(rs.next()){
                String codMaterial=rs.getString(1);
                String nombreMaterial=rs.getString(2);
                String unidadMedida=rs.getString(3);
                String cantidad=rs.getString(4);
                String codUnidadMedida=rs.getString(5);
                FormulaMaestraDetalleMP bean=new FormulaMaestraDetalleMP();
                bean.getMateriales().setCodMaterial(codMaterial);
                bean.getMateriales().setNombreMaterial(nombreMaterial);
                bean.getUnidadesMedida().setNombreUnidadMedida(unidadMedida);
                bean.setCantidad(cantidad);
                bean.getUnidadesMedida().setCodUnidadMedida(codUnidadMedida);
                String sql_1=" select * from PROGRAMA_PRODUCCION_DETALLE pp where pp.cod_programa_prod='"+getCodigo()+"' and pp.COD_MATERIAL="+codMaterial ;
                System.out.println("sql _1:"+sql_1);
                Statement st1=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                ResultSet rs1=st1.executeQuery(sql_1);
                while(rs1.next()){
                    formulaMaestraEPList.add(bean);
                }
                
            }
            sql=" select m.cod_material,m.NOMBRE_MATERIAL,um.NOMBRE_UNIDAD_MEDIDA,ppd.CANTIDAD,um.COD_UNIDAD_MEDIDA from FORMULA_MAESTRA_DETALLE_ES mp,MATERIALES m,UNIDADES_MEDIDA um,PROGRAMA_PRODUCCION_DETALLE ppd" ;
            sql+=" where  m.COD_MATERIAL=mp.cod_material and um.COD_UNIDAD_MEDIDA=m.COD_UNIDAD_MEDIDA and ppd.COD_MATERIAL=m.COD_MATERIAL and mp.cod_formula_maestra="+codFormulaMaestra;
            System.out.println("sql ES:"+sql);
            st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            rs=st.executeQuery(sql);
            while(rs.next()){
                String codMaterial=rs.getString(1);
                String nombreMaterial=rs.getString(2);
                String unidadMedida=rs.getString(3);
                String cantidad=rs.getString(4);
                String codUnidadMedida=rs.getString(5);
                FormulaMaestraDetalleMP bean=new FormulaMaestraDetalleMP();
                bean.getMateriales().setCodMaterial(codMaterial);
                bean.getMateriales().setNombreMaterial(nombreMaterial);
                bean.getUnidadesMedida().setNombreUnidadMedida(unidadMedida);
                bean.setCantidad(cantidad);
                bean.getUnidadesMedida().setCodUnidadMedida(codUnidadMedida);
                String sql_1=" select * from PROGRAMA_PRODUCCION_DETALLE pp where pp.cod_programa_prod='"+getCodigo()+"' and pp.COD_MATERIAL="+codMaterial ;
                System.out.println("sql _1:"+sql_1);
                Statement st1=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                ResultSet rs1=st1.executeQuery(sql_1);
                while(rs1.next()){
                    formulaMaestraESList.add(bean);
                }
                
            }
            sql=" select m.cod_material,m.NOMBRE_MATERIAL,um.NOMBRE_UNIDAD_MEDIDA,ppd.CANTIDAD,um.COD_UNIDAD_MEDIDA from FORMULA_MAESTRA_DETALLE_MPROM mp,MATERIALES m,UNIDADES_MEDIDA um,PROGRAMA_PRODUCCION_DETALLE ppd" ;
            sql+=" where  m.COD_MATERIAL=mp.cod_material and um.COD_UNIDAD_MEDIDA=m.COD_UNIDAD_MEDIDA and ppd.COD_MATERIAL=m.COD_MATERIAL and mp.cod_formula_maestra="+codFormulaMaestra;
            System.out.println("sql MPROM:"+sql);
            st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            rs=st.executeQuery(sql);
            while(rs.next()){
                String codMaterial=rs.getString(1);
                String nombreMaterial=rs.getString(2);
                String unidadMedida=rs.getString(3);
                String cantidad=rs.getString(4);
                String codUnidadMedida=rs.getString(5);
                FormulaMaestraDetalleMP bean=new FormulaMaestraDetalleMP();
                bean.getMateriales().setCodMaterial(codMaterial);
                bean.getMateriales().setNombreMaterial(nombreMaterial);
                bean.getUnidadesMedida().setNombreUnidadMedida(unidadMedida);
                bean.setCantidad(cantidad);
                bean.getUnidadesMedida().setCodUnidadMedida(codUnidadMedida);
                String sql_1=" select * from PROGRAMA_PRODUCCION_DETALLE pp where pp.cod_programa_prod='"+getCodigo()+"' and pp.COD_MATERIAL="+codMaterial ;
                System.out.println("sql _1:"+sql_1);
                Statement st1=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                ResultSet rs1=st1.executeQuery(sql_1);
                while(rs1.next()){
                    formulaMaestraMPROMList.add(bean);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return"";
    }
    
    
    public String eliminarProgProd(){
        try {
            setCon(Util.openConnection(getCon()));
            Iterator i=programaProduccionList.iterator();
            int result=0;
            while (i.hasNext()){
                
                //
                ProgramaProduccion bean=(ProgramaProduccion)i.next();
                if(bean.getChecked().booleanValue()){
                    String sql="delete from PROGRAMA_PRODUCCION_DETALLE where COD_PROGRAMA_PROD='"+bean.getCodProgramaProduccion()+"' ";
                    System.out.println("PROGRAMA_PRODUCCION_DETALLE:sql:"+sql);
                    Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    result=result+st.executeUpdate(sql);
                    sql="delete from PROGRAMA_PRODUCCION where COD_PROGRAMA_PROD='"+bean.getCodProgramaProduccion()+"' ";
                    System.out.println("PROGRAMA_PRODUCCION:sql:"+sql);
                    st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    result=result+st.executeUpdate(sql);
                    sql="delete from reserva where nro_op='"+bean.getCodProgramaProduccion()+"' ";
                    System.out.println("PROGRAMA_PRODUCCION reserva:sql:"+sql);
                    st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    result=result+st.executeUpdate(sql);
                    sql="delete from reserva_detalle where nro_op='"+bean.getCodProgramaProduccion()+"' ";
                    System.out.println("PROGRAMA_PRODUCCION reserva:sql:"+sql);
                    st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    result=result+st.executeUpdate(sql);
                }
            }
            if(result>0){
                cargarProgramaProduccion();
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "navegadorProgramaProduccion";
    }
    /* ------------------Métodos---------------------------*/
   /* public void changeEventLote(javax.faces.event.ValueChangeEvent event){
        System.out.println("event 2:"+event.getNewValue());
        String cantidad_prod=event.getNewValue().toString();
        double cantProduccion=Double.parseDouble(cantidad_prod);
        formulaMaestraMPList.clear();
        formulaMaestraEPList.clear();
        formulaMaestraESList.clear();
        formulaMaestraMPROMList.clear();
        NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
        DecimalFormat form = (DecimalFormat)nf;
        form.applyPattern("#,###.00");
        String codFormulaMaestra=programaProduccionbean.getFormulaMaestra().getCodFormulaMaestra();
        try {
            String sql_lote="  select f.CANTIDAD_LOTE from FORMULA_MAESTRA f where f.COD_FORMULA_MAESTRA='"+programaProduccionbean.getFormulaMaestra().getCodFormulaMaestra()+"'" ;
            
            System.out.println("sql_lote:"+sql_lote);
            setCon(Util.openConnection(getCon()));
            Statement st_lote=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs_lote=st_lote.executeQuery(sql_lote);
            double cantidad_lote_formula=0;
            while(rs_lote.next()){
                cantidad_lote_formula=rs_lote.getDouble(1);
            }
            
            String sql=" select m.cod_material,m.NOMBRE_MATERIAL,um.NOMBRE_UNIDAD_MEDIDA,mp.CANTIDAD,um.COD_UNIDAD_MEDIDA from FORMULA_MAESTRA_DETALLE_MP mp,MATERIALES m,UNIDADES_MEDIDA um" ;
            sql+=" where  m.COD_MATERIAL=mp.cod_material and um.COD_UNIDAD_MEDIDA=m.COD_UNIDAD_MEDIDA and mp.cod_formula_maestra="+codFormulaMaestra;
            System.out.println("sql MP:"+sql);
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(sql);
            while(rs.next()){
                String codMaterial=rs.getString(1);
                String nombreMaterial=rs.getString(2);
                String unidadMedida=rs.getString(3);
                double cantidad=rs.getDouble(4);
                cantidad= (cantProduccion*cantidad)/cantidad_lote_formula;
                cantidad=redondear(cantidad,3);
                String codUnidadMedida=rs.getString(5);
                FormulaMaestraDetalleMP bean=new FormulaMaestraDetalleMP();
                bean.getMateriales().setCodMaterial(codMaterial);
                bean.getMateriales().setNombreMaterial(nombreMaterial);
                bean.getUnidadesMedida().setNombreUnidadMedida(unidadMedida);
                bean.setCantidad(form.format(cantidad));
                bean.getUnidadesMedida().setCodUnidadMedida(codUnidadMedida);
                bean.setChecked(true);
                formulaMaestraMPList.add(bean);
            }
            sql=" select m.cod_material,m.NOMBRE_MATERIAL,um.NOMBRE_UNIDAD_MEDIDA,mp.CANTIDAD,um.COD_UNIDAD_MEDIDA from FORMULA_MAESTRA_DETALLE_EP mp,MATERIALES m,UNIDADES_MEDIDA um" ;
            sql+=" where  m.COD_MATERIAL=mp.cod_material and um.COD_UNIDAD_MEDIDA=m.COD_UNIDAD_MEDIDA and mp.cod_formula_maestra="+codFormulaMaestra;
            System.out.println("sql EP:"+sql);
            st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            rs=st.executeQuery(sql);
            while(rs.next()){
                String codMaterial=rs.getString(1);
                String nombreMaterial=rs.getString(2);
                String unidadMedida=rs.getString(3);
                double cantidad=rs.getDouble(4);
                cantidad= (cantProduccion*cantidad)/cantidad_lote_formula;
                cantidad=redondear(cantidad,3);
                String codUnidadMedida=rs.getString(5);
                FormulaMaestraDetalleMP bean=new FormulaMaestraDetalleMP();
                bean.getMateriales().setCodMaterial(codMaterial);
                bean.getMateriales().setNombreMaterial(nombreMaterial);
                bean.getUnidadesMedida().setNombreUnidadMedida(unidadMedida);
                bean.setCantidad(form.format(cantidad));
                bean.getUnidadesMedida().setCodUnidadMedida(codUnidadMedida);
                bean.setChecked(true);
                formulaMaestraEPList.add(bean);
            }
            sql=" select m.cod_material,m.NOMBRE_MATERIAL,um.NOMBRE_UNIDAD_MEDIDA,mp.CANTIDAD,um.COD_UNIDAD_MEDIDA from FORMULA_MAESTRA_DETALLE_ES mp,MATERIALES m,UNIDADES_MEDIDA um" ;
            sql+=" where  m.COD_MATERIAL=mp.cod_material and um.COD_UNIDAD_MEDIDA=m.COD_UNIDAD_MEDIDA and mp.cod_formula_maestra="+codFormulaMaestra;
            System.out.println("sql ES:"+sql);
            st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            rs=st.executeQuery(sql);
            while(rs.next()){
                String codMaterial=rs.getString(1);
                String nombreMaterial=rs.getString(2);
                String unidadMedida=rs.getString(3);
                double cantidad=rs.getDouble(4);
                cantidad= (cantProduccion*cantidad)/cantidad_lote_formula;
                cantidad=redondear(cantidad,3);
                String codUnidadMedida=rs.getString(5);
                FormulaMaestraDetalleMP bean=new FormulaMaestraDetalleMP();
                bean.getMateriales().setCodMaterial(codMaterial);
                bean.getMateriales().setNombreMaterial(nombreMaterial);
                bean.getUnidadesMedida().setNombreUnidadMedida(unidadMedida);
                bean.setCantidad(form.format(cantidad));
                bean.getUnidadesMedida().setCodUnidadMedida(codUnidadMedida);
                bean.setChecked(true);
                formulaMaestraESList.add(bean);
            }
            sql=" select m.cod_material,m.NOMBRE_MATERIAL,um.NOMBRE_UNIDAD_MEDIDA,mp.CANTIDAD,um.COD_UNIDAD_MEDIDA from FORMULA_MAESTRA_DETALLE_MPROM mp,MATERIALES m,UNIDADES_MEDIDA um" ;
            sql+=" where  m.COD_MATERIAL=mp.cod_material and um.COD_UNIDAD_MEDIDA=m.COD_UNIDAD_MEDIDA and mp.cod_formula_maestra="+codFormulaMaestra;
            System.out.println("sql MPROM:"+sql);
            st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            rs=st.executeQuery(sql);
            while(rs.next()){
                String codMaterial=rs.getString(1);
                String nombreMaterial=rs.getString(2);
                String unidadMedida=rs.getString(3);
                double cantidad=rs.getDouble(4);
                cantidad= (cantProduccion*cantidad)/cantidad_lote_formula;
                cantidad=redondear(cantidad,3);
                String codUnidadMedida=rs.getString(5);
                FormulaMaestraDetalleMP bean=new FormulaMaestraDetalleMP();
                bean.getMateriales().setCodMaterial(codMaterial);
                bean.getMateriales().setNombreMaterial(nombreMaterial);
                bean.getUnidadesMedida().setNombreUnidadMedida(unidadMedida);
                bean.setCantidad(form.format(cantidad));
                bean.getUnidadesMedida().setCodUnidadMedida(codUnidadMedida);
                bean.setChecked(true);
                formulaMaestraMPROMList.add(bean);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
    }
    
    
    
    
    */
    
    
    
    
    
    public double redondear( double numero, int decimales ) {
        return Math.round(numero*Math.pow(10,decimales))/Math.pow(10,decimales);
    }
    
    
    
    
    
    
    
    
    public static void main(String[] args) {
        int a1,m1,d1,a2,m2,d2;
        String fe_inicio="05-1-2008";
        System.out.println("fe_inicio:"+fe_inicio);
        String fe_final="05-31-2008";
        System.out.println("fe_final:"+fe_final);
        /*String []Inicio=fe_inicio.split("-");
        String []Final=fe_final.split("-");
         
        d1=Integer.parseInt(Final[1]);
        m1=Integer.parseInt(Final[0]);
        a1=Integer.parseInt(Final[2]);
        d2=Integer.parseInt(Inicio[1]);
        m2=Integer.parseInt(Inicio[0]);
        a2=Integer.parseInt(Inicio[2]);
         
        DateTime start = new DateTime(a2, m2, d2, 0, 0, 0, 0);
        System.out.println("start:"+start);
        DateTime end = new DateTime(a1, m1, d1, 0, 0, 0, 0);
        System.out.println("end:"+end);
        int count=0;
        while (start.compareTo(end)<=0){
            if(start.getDayOfWeek()==7){
                count=count+1;
         
            }
        }
        System.out.println("count :"+count);
         */
    }
    
    public AreasFabricacion getAreasFabricacionbean() {
        return areasFabricacionbean;
    }
    
    public void setAreasFabricacionbean(AreasFabricacion areasFabricacionbean) {
        this.areasFabricacionbean = areasFabricacionbean;
    }
    
    public List<AreasFabricacion> getAreasFabricacionList() {
        return areasFabricacionList;
    }
    
    public void setAreasFabricacionList(List<AreasFabricacion> areasFabricacionList) {
        this.areasFabricacionList = areasFabricacionList;
    }
    
    public List getAreasFabricacionEliminarList() {
        return areasFabricacionEliminarList;
    }
    
    public void setAreasFabricacionEliminarList(List areasFabricacionEliminarList) {
        this.areasFabricacionEliminarList = areasFabricacionEliminarList;
    }
    
    public List getAreasFabricacionNoEliminarList() {
        return areasFabricacionNoEliminarList;
    }
    
    public void setAreasFabricacionNoEliminarList(List areasFabricacionNoEliminarList) {
        this.areasFabricacionNoEliminarList = areasFabricacionNoEliminarList;
    }
    
    public Connection getCon() {
        return con;
    }
    
    public void setCon(Connection con) {
        this.con = con;
    }
    
    public String getCodigo() {
        return codigo;
    }
    
    public void setCodigo(String codigo) {
        this.codigo = codigo;
    }
    
    public boolean isSwEliminaSi() {
        return swEliminaSi;
    }
    
    public void setSwEliminaSi(boolean swEliminaSi) {
        this.swEliminaSi = swEliminaSi;
    }
    
    public boolean isSwEliminaNo() {
        return swEliminaNo;
    }
    
    public void setSwEliminaNo(boolean swEliminaNo) {
        this.swEliminaNo = swEliminaNo;
    }
  
    
}
