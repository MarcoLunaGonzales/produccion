/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.dao;
import com.cofar.bean.ActividadFormulaMaestraBloque;
import com.cofar.bean.ActividadesFormulaMaestra;
import com.cofar.bean.ActividadesFormulaMaestraHorasEstandarMaquinaria;
import com.cofar.util.Util;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import org.apache.logging.log4j.LogManager;

/**
 *
 * @author DASISAQ
 */
public class DaoActividadesFormulaMaestra extends DaoBean{

    public DaoActividadesFormulaMaestra() {
        LOGGER=LogManager.getRootLogger();
    }
    
    public boolean eliminar(int codActividadFormulaMaestra)throws SQLException
    {
        boolean transaccionExitosa=false;
        try 
        {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta = new StringBuilder("delete ACTIVIDADES_FORMULA_MAESTRA ");
                                    consulta.append(" where COD_ACTIVIDAD_FORMULA=").append(codActividadFormulaMaestra);
            LOGGER.debug("consulta  deleta actividad formula " + consulta.toString());
            PreparedStatement pst = con.prepareStatement(consulta.toString());
            if (pst.executeUpdate() > 0) LOGGER.info("Se elimino la transacción");
            consulta=new StringBuilder("delete ACTIVIDADES_PROGRAMA_PRODUCCION ");
                        consulta.append(" where COD_ACTIVIDAD_PROGRAMA=").append(codActividadFormulaMaestra);
            LOGGER.debug("consulta eliminar actividad programa "+consulta.toString());
            pst=con.prepareStatement(consulta.toString());
            if(pst.executeUpdate()>0)LOGGER.info("se elimino la actividad programa ");
            consulta=new StringBuilder("delete ACTIVIDADES_FORMULA_MAESTRA_HORAS_ESTANDAR_MAQUINARIA");
                        consulta.append(" where COD_ACTIVIDAD_FORMULA=").append(codActividadFormulaMaestra);
            LOGGER.debug("consulta eliminar actividad maquinaria formula "+consulta.toString());
            pst=con.prepareStatement(consulta.toString());
            if(pst.executeUpdate()>0)LOGGER.info("se eliminaron las maquinarias");
            con.commit();
            transaccionExitosa=true;
            pst.close();
        }
        catch (SQLException ex) 
        {
            transaccionExitosa=false;
            LOGGER.warn(ex.getMessage());
            con.rollback();
        } 
        catch (Exception ex) 
        {
            transaccionExitosa=false;
            LOGGER.warn(ex.getMessage());
            con.rollback();
        }
        finally 
        {
            this.cerrarConexion(con);
        }
               
        return transaccionExitosa;
    }
    
    public int cantidadRegistrosRelacionados(int actividadesFormulaMaestra)
    {
        int cantidadRegistros=0;
        try 
        {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select count(*) as cantidadRegistros");
                                        consulta.append(" from SEGUIMIENTO_PROGRAMA_PRODUCCION spp");
                                        consulta.append(" where spp.COD_ACTIVIDAD_PROGRAMA=").append(actividadesFormulaMaestra);
            LOGGER.debug("consulta verificar seguimiento registrado con actividad "+consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            if(res.next()) cantidadRegistros+=res.getInt(1);
            consulta=new StringBuilder("select count(*) as cantidadRegistros");
                        consulta.append(" from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL spp");
                        consulta.append(" where spp.COD_ACTIVIDAD_PROGRAMA=").append(actividadesFormulaMaestra);
            LOGGER.debug("consulta verficar seguimiento personal "+consulta.toString());
            res=st.executeQuery(consulta.toString());
            if(res.next())cantidadRegistros+=res.getInt(1);
            st.close();
        }
        catch (SQLException ex) 
        {
            LOGGER.warn("error", ex);
        }
        finally 
        {
            this.cerrarConexion(con);
        }
        return cantidadRegistros;
    }
    
    public List<ActividadesFormulaMaestra> listarNoAsociadasABloque(ActividadesFormulaMaestra actividadesFormulaMaestraBuscar)
    {
        List<ActividadesFormulaMaestra> actividadesFormulaMaestraList=new ArrayList<ActividadesFormulaMaestra>();
        try 
        {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select afm.COD_ACTIVIDAD_FORMULA,ap.COD_ACTIVIDAD,ap.NOMBRE_ACTIVIDAD,afm.ORDEN_ACTIVIDAD")
                                                .append(" from ACTIVIDADES_FORMULA_MAESTRA afm")
                                                        .append(" inner join ACTIVIDADES_PRODUCCION ap on ap.COD_ACTIVIDAD=afm.COD_ACTIVIDAD")
                                                .append(" where afm.COD_FORMULA_MAESTRA=").append(actividadesFormulaMaestraBuscar.getFormulaMaestra().getCodFormulaMaestra())
                                                        .append(" and afm.COD_ESTADO_REGISTRO=").append(actividadesFormulaMaestraBuscar.getEstadoReferencial().getCodEstadoRegistro())
                                                        .append(" and afm.COD_TIPO_PROGRAMA_PROD=").append(actividadesFormulaMaestraBuscar.getTiposProgramaProduccion().getCodTipoProgramaProd())
                                                        .append(" and afm.COD_PRESENTACION=").append(actividadesFormulaMaestraBuscar.getPresentacionesProducto().getCodPresentacion())
                                                        .append(" and afm.COD_AREA_EMPRESA=").append(actividadesFormulaMaestraBuscar.getAreasEmpresa().getCodAreaEmpresa())
                                                        .append(" and afm.COD_ACTIVIDAD_FORMULA_MAESTRA_BLOQUE is null")
                                                .append(" order by afm.ORDEN_ACTIVIDAD");
            LOGGER.debug("consulta cargar actividades formula maestra no incluidas en bloque"+consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            while (res.next()) 
            {
                ActividadesFormulaMaestra actividadesFormulaMaestra=new ActividadesFormulaMaestra();
                actividadesFormulaMaestra.setCodActividadFormula(res.getInt("COD_ACTIVIDAD_FORMULA"));
                actividadesFormulaMaestra.setOrdenActividad(res.getInt("ORDEN_ACTIVIDAD"));
                actividadesFormulaMaestra.getActividadesProduccion().setCodActividad(res.getInt("COD_ACTIVIDAD"));
                actividadesFormulaMaestra.getActividadesProduccion().setNombreActividad(res.getString("NOMBRE_ACTIVIDAD"));
                actividadesFormulaMaestraList.add(actividadesFormulaMaestra);
                
            }
            
        } catch (SQLException ex) {
            LOGGER.warn(ex.getMessage());
        } catch (NumberFormatException ex) {
            LOGGER.warn(ex.getMessage());
        } finally {
            this.cerrarConexion(con);
        }
        return actividadesFormulaMaestraList;
    }
    
    public List<ActividadFormulaMaestraBloque> listarPorBloque(ActividadesFormulaMaestra actividadesFormulaMaestraBuscar)
    {
        List<ActividadFormulaMaestraBloque> actividadFormulaMaestraBloqueList=new ArrayList<ActividadFormulaMaestraBloque>();
        try 
        {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select afm.COD_FORMULA_MAESTRA,afm.COD_ACTIVIDAD_FORMULA,afm.ORDEN_ACTIVIDAD,ap.COD_ACTIVIDAD,ap.NOMBRE_ACTIVIDAD,");
                                                consulta.append(" afm.COD_AREA_EMPRESA,ae.NOMBRE_AREA_EMPRESA,afm.COD_TIPO_PROGRAMA_PROD,tpp.NOMBRE_TIPO_PROGRAMA_PROD,");
                                                consulta.append(" afm.COD_PRESENTACION,pp.NOMBRE_PRODUCTO_PRESENTACION,m.NOMBRE_MAQUINA,m.CODIGO,");
                                                consulta.append(" afme.COD_ACTIVIDADES_FORMULA_MAESTRA_HORAS_ESTANDAR_MAQUINARIA,");
                                                consulta.append(" afm.COD_ESTADO_REGISTRO,er.NOMBRE_ESTADO_REGISTRO,");
                                                consulta.append(" afme.COD_MAQUINA,afme.HORAS_MAQUINA_ESTANDAR,")
                                                        .append(" ap.COD_PROCESO_ORDEN_MANUFACTURA,pom.NOMBRE_PROCESO_ORDEN_MANUFACTURA,")
                                                        .append(" isnull(afmb.COD_ACTIVIDAD_FORMULA_MAESTRA_BLOQUE,-1) as COD_ACTIVIDAD_FORMULA_MAESTRA_BLOQUE,afmb.HORAS_HOMBRE_ESTANDAR,afmb.DESCRIPCION");
                                        consulta.append(" from ACTIVIDADES_FORMULA_MAESTRA afm");
                                                consulta.append(" left outer join ACTIVIDAD_FORMULA_MAESTRA_BLOQUE afmb on afmb.COD_ACTIVIDAD_FORMULA_MAESTRA_BLOQUE=afm.COD_ACTIVIDAD_FORMULA_MAESTRA_BLOQUE");
                                                consulta.append(" inner join ACTIVIDADES_PRODUCCION ap on ap.COD_ACTIVIDAD=afm.COD_ACTIVIDAD");
                                                consulta.append(" LEFT OUTER join PROCESOS_ORDEN_MANUFACTURA pom on pom.COD_PROCESO_ORDEN_MANUFACTURA=ap.COD_PROCESO_ORDEN_MANUFACTURA");
                                                consulta.append(" inner join ESTADOS_REFERENCIALES er on er.COD_ESTADO_REGISTRO=afm.COD_ESTADO_REGISTRO");
                                                consulta.append(" inner join AREAS_EMPRESA ae on ae.COD_AREA_EMPRESA=afm.COD_AREA_EMPRESA");
                                                consulta.append(" left outer join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD=afm.COD_TIPO_PROGRAMA_PROD");
                                                consulta.append(" left outer join PRESENTACIONES_PRODUCTO pp on pp.cod_presentacion=afm.COD_PRESENTACION");
                                                consulta.append(" left outer join ACTIVIDADES_FORMULA_MAESTRA_HORAS_ESTANDAR_MAQUINARIA afme on afme.COD_ACTIVIDAD_FORMULA=afm.COD_ACTIVIDAD_FORMULA");
                                                consulta.append(" left outer join maquinarias m on m.COD_MAQUINA=afme.COD_MAQUINA");
                                        consulta.append(" where afm.COD_FORMULA_MAESTRA=").append(actividadesFormulaMaestraBuscar.getFormulaMaestra().getCodFormulaMaestra());
                                                consulta.append(" and afm.COD_ESTADO_REGISTRO=").append(actividadesFormulaMaestraBuscar.getEstadoReferencial().getCodEstadoRegistro());
                                                consulta.append(" and afm.COD_TIPO_PROGRAMA_PROD=").append(actividadesFormulaMaestraBuscar.getTiposProgramaProduccion().getCodTipoProgramaProd());
                                                consulta.append(" and afm.COD_PRESENTACION=").append(actividadesFormulaMaestraBuscar.getPresentacionesProducto().getCodPresentacion());
                                                consulta.append(" and afm.COD_AREA_EMPRESA=").append(actividadesFormulaMaestraBuscar.getAreasEmpresa().getCodAreaEmpresa());
                                        consulta.append(" order by afm.ORDEN_ACTIVIDAD,ap.NOMBRE_ACTIVIDAD,afm.COD_ACTIVIDAD");
            LOGGER.debug("consulta cargar actividades formula maestra "+consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            ActividadFormulaMaestraBloque bean=new ActividadFormulaMaestraBloque();
            ActividadesFormulaMaestra actividadesFormulaMaestra=new ActividadesFormulaMaestra();
            while (res.next()) 
            {
                if(bean.getCodActividadFormulaMaestraBloque()!=res.getInt("COD_ACTIVIDAD_FORMULA_MAESTRA_BLOQUE"))
                {
                    LOGGER.debug("entro distinto");
                    if(bean.getCodActividadFormulaMaestraBloque()!=0)
                    {
                        bean.getActividadesFormulaMaestraList().add(actividadesFormulaMaestra);
                        actividadFormulaMaestraBloqueList.add(bean);
                    }
                    bean=new ActividadFormulaMaestraBloque();
                    actividadesFormulaMaestra=new ActividadesFormulaMaestra();
                    bean.setDescripcion(res.getString("DESCRIPCION"));
                    bean.setHorasHombreEstandar(res.getDouble("HORAS_HOMBRE_ESTANDAR"));
                    bean.setCodActividadFormulaMaestraBloque(res.getInt("COD_ACTIVIDAD_FORMULA_MAESTRA_BLOQUE"));
                    bean.setActividadesFormulaMaestraList(new ArrayList<ActividadesFormulaMaestra>());
                }
                if(actividadesFormulaMaestra.getCodActividadFormula()!=res.getInt("COD_ACTIVIDAD_FORMULA"))
                {
                    if(actividadesFormulaMaestra.getCodActividadFormula()>0)
                    {
                        bean.getActividadesFormulaMaestraList().add(actividadesFormulaMaestra);
                    }
                    actividadesFormulaMaestra=new ActividadesFormulaMaestra();
                    actividadesFormulaMaestra.getEstadoReferencial().setCodEstadoRegistro(res.getString("COD_ESTADO_REGISTRO"));
                    actividadesFormulaMaestra.getEstadoReferencial().setNombreEstadoRegistro(res.getString("NOMBRE_ESTADO_REGISTRO"));
                    actividadesFormulaMaestra.setCodActividadFormula(res.getInt("COD_ACTIVIDAD_FORMULA"));
                    actividadesFormulaMaestra.setOrdenActividad(res.getInt("ORDEN_ACTIVIDAD"));
                    actividadesFormulaMaestra.getActividadesProduccion().setCodActividad(res.getInt("COD_ACTIVIDAD"));
                    actividadesFormulaMaestra.getActividadesProduccion().setNombreActividad(res.getString("NOMBRE_ACTIVIDAD"));
                    actividadesFormulaMaestra.getActividadesProduccion().getProcesosOrdenManufactura().setCodProcesoOrdenManufactura(res.getInt("COD_PROCESO_ORDEN_MANUFACTURA"));
                    actividadesFormulaMaestra.getActividadesProduccion().getProcesosOrdenManufactura().setNombreProcesoOrdenManufactura(res.getString("NOMBRE_PROCESO_ORDEN_MANUFACTURA"));
                    actividadesFormulaMaestra.getFormulaMaestra().setCodFormulaMaestra(res.getString("COD_FORMULA_MAESTRA"));
                    actividadesFormulaMaestra.getAreasEmpresa().setCodAreaEmpresa(res.getString("COD_AREA_EMPRESA"));
                    actividadesFormulaMaestra.getAreasEmpresa().setNombreAreaEmpresa(res.getString("NOMBRE_AREA_EMPRESA"));
                    actividadesFormulaMaestra.getTiposProgramaProduccion().setCodTipoProgramaProd(res.getString("COD_TIPO_PROGRAMA_PROD"));
                    actividadesFormulaMaestra.getTiposProgramaProduccion().setNombreTipoProgramaProd(res.getString("NOMBRE_TIPO_PROGRAMA_PROD"));
                    actividadesFormulaMaestra.getPresentacionesProducto().setCodPresentacion(res.getString("COD_PRESENTACION"));
                    actividadesFormulaMaestra.getPresentacionesProducto().setNombreProductoPresentacion(res.getString("NOMBRE_PRODUCTO_PRESENTACION"));
                    actividadesFormulaMaestra.getActividadFormulaMaestraBloque().setCodActividadFormulaMaestraBloque(res.getInt("COD_ACTIVIDAD_FORMULA_MAESTRA_BLOQUE"));
                    actividadesFormulaMaestra.setActividadesFormulaMaestraHorasEstandarMaquinariaList(new ArrayList<ActividadesFormulaMaestraHorasEstandarMaquinaria>());
                }
                ActividadesFormulaMaestraHorasEstandarMaquinaria detalle=new ActividadesFormulaMaestraHorasEstandarMaquinaria();
                detalle.setCodActividadesFormulaMaestraHorasEstandarMaquinaria(res.getInt("COD_ACTIVIDADES_FORMULA_MAESTRA_HORAS_ESTANDAR_MAQUINARIA"));
                detalle.getMaquinaria().setCodMaquina(res.getString("COD_MAQUINA"));
                detalle.getMaquinaria().setCodigo(res.getString("CODIGO"));
                detalle.getMaquinaria().setNombreMaquina(res.getString("NOMBRE_MAQUINA"));
                detalle.setHorasHombreEstandar(res.getDouble("HORAS_HOMBRE_ESTANDAR"));
                detalle.setHorasMaquinaEstandar(res.getDouble("HORAS_MAQUINA_ESTANDAR"));
                actividadesFormulaMaestra.getActividadesFormulaMaestraHorasEstandarMaquinariaList().add(detalle);
                   
            }
            if(bean.getCodActividadFormulaMaestraBloque()!=0)
            {
                bean.getActividadesFormulaMaestraList().add(actividadesFormulaMaestra);
                actividadFormulaMaestraBloqueList.add(bean);
            }
            
        } catch (SQLException ex) {
            LOGGER.warn(ex.getMessage());
        } catch (NumberFormatException ex) {
            LOGGER.warn(ex.getMessage());
        } finally {
            this.cerrarConexion(con);
        }
        return actividadFormulaMaestraBloqueList;
        
    }
    
    public List<ActividadesFormulaMaestra> listarActividadesFormulaMaestra(ActividadesFormulaMaestra actividadesFormulaMaestraBuscar)
    {
        List<ActividadesFormulaMaestra> actividadesFormulaMaestraList=new ArrayList<ActividadesFormulaMaestra>();
        try 
        {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select pp.cod_presentacion,pp.NOMBRE_PRODUCTO_PRESENTACION");
                                        consulta.append(" from PRESENTACIONES_PRODUCTO pp");
                                        consulta.append(" where pp.cod_estado_registro=1");
                                        consulta.append(" order by pp.NOMBRE_PRODUCTO_PRESENTACION");
            LOGGER.debug(" consulta cargar tipos programa produccion "+consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            while(res.next()) 
            {
                ActividadesFormulaMaestra nuevo=new ActividadesFormulaMaestra();
                actividadesFormulaMaestraList.add(nuevo);
            }
            
        }
        catch (SQLException ex) 
        {
            LOGGER.warn(ex.getMessage());
        }
        finally 
        {
            this.cerrarConexion(con);
        }
        return actividadesFormulaMaestraList;
    }
    public List<ActividadesFormulaMaestra> listar(ActividadesFormulaMaestra actividadesFormulaMaestraBuscar)
    {
        List<ActividadesFormulaMaestra> actividadesFormulaMaestraList=new ArrayList<ActividadesFormulaMaestra>();
        try 
        {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select afm.COD_FORMULA_MAESTRA,afm.COD_ACTIVIDAD_FORMULA,afm.ORDEN_ACTIVIDAD,ap.COD_ACTIVIDAD,ap.NOMBRE_ACTIVIDAD,");
                                                consulta.append(" afm.COD_AREA_EMPRESA,ae.NOMBRE_AREA_EMPRESA,afm.COD_TIPO_PROGRAMA_PROD,tpp.NOMBRE_TIPO_PROGRAMA_PROD,");
                                                consulta.append(" afm.COD_PRESENTACION,pp.NOMBRE_PRODUCTO_PRESENTACION,m.NOMBRE_MAQUINA,m.CODIGO,");
                                                consulta.append(" afme.COD_ACTIVIDADES_FORMULA_MAESTRA_HORAS_ESTANDAR_MAQUINARIA,");
                                                consulta.append(" afm.COD_ESTADO_REGISTRO,er.NOMBRE_ESTADO_REGISTRO,");
                                                consulta.append(" afme.COD_MAQUINA,afme.HORAS_HOMBRE_ESTANDAR,afme.HORAS_MAQUINA_ESTANDAR,");
                                                consulta.append(" ap.COD_PROCESO_ORDEN_MANUFACTURA,pom.NOMBRE_PROCESO_ORDEN_MANUFACTURA,")
                                                        .append(" afm.COD_ACTIVIDAD_FORMULA_MAESTRA_BLOQUE");
                                        consulta.append(" from ACTIVIDADES_FORMULA_MAESTRA afm");
                                                consulta.append(" inner join ACTIVIDADES_PRODUCCION ap on ap.COD_ACTIVIDAD=afm.COD_ACTIVIDAD");
                                                consulta.append(" LEFT OUTER join PROCESOS_ORDEN_MANUFACTURA pom on pom.COD_PROCESO_ORDEN_MANUFACTURA=ap.COD_PROCESO_ORDEN_MANUFACTURA");
                                                consulta.append(" inner join ESTADOS_REFERENCIALES er on er.COD_ESTADO_REGISTRO=afm.COD_ESTADO_REGISTRO");
                                                consulta.append(" inner join AREAS_EMPRESA ae on ae.COD_AREA_EMPRESA=afm.COD_AREA_EMPRESA");
                                                consulta.append(" left outer join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD=afm.COD_TIPO_PROGRAMA_PROD");
                                                consulta.append(" left outer join PRESENTACIONES_PRODUCTO pp on pp.cod_presentacion=afm.COD_PRESENTACION");
                                                consulta.append(" left outer join ACTIVIDADES_FORMULA_MAESTRA_HORAS_ESTANDAR_MAQUINARIA afme on afme.COD_ACTIVIDAD_FORMULA=afm.COD_ACTIVIDAD_FORMULA");
                                                consulta.append(" left outer join maquinarias m on m.COD_MAQUINA=afme.COD_MAQUINA");
                                        consulta.append(" where afm.COD_FORMULA_MAESTRA=").append(actividadesFormulaMaestraBuscar.getFormulaMaestra().getCodFormulaMaestra());
                                                consulta.append(" and afm.COD_TIPO_PROGRAMA_PROD=").append(actividadesFormulaMaestraBuscar.getTiposProgramaProduccion().getCodTipoProgramaProd());
                                                consulta.append(" and afm.COD_PRESENTACION=").append(actividadesFormulaMaestraBuscar.getPresentacionesProducto().getCodPresentacion());
                                                consulta.append(" and afm.COD_AREA_EMPRESA=").append(actividadesFormulaMaestraBuscar.getAreasEmpresa().getCodAreaEmpresa());
                                                if( !(actividadesFormulaMaestraBuscar.getEstadoReferencial().getCodEstadoRegistro().equals("") || actividadesFormulaMaestraBuscar.getEstadoReferencial().getCodEstadoRegistro().equals("0")))
                                                        consulta.append(" and afm.COD_ESTADO_REGISTRO=").append(actividadesFormulaMaestraBuscar.getEstadoReferencial().getCodEstadoRegistro());
                                                if( actividadesFormulaMaestraBuscar.getActividadFormulaMaestraBloque().getCodActividadFormulaMaestraBloque()>0)
                                                        consulta.append(" and afm.COD_ACTIVIDAD_FORMULA_MAESTRA_BLOQUE=").append(actividadesFormulaMaestraBuscar.getActividadFormulaMaestraBloque().getCodActividadFormulaMaestraBloque());
                                        consulta.append(" order by afm.ORDEN_ACTIVIDAD,ap.NOMBRE_ACTIVIDAD,afm.COD_ACTIVIDAD");
            LOGGER.debug("consulta cargar actividades formula maestra "+consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            ActividadesFormulaMaestra bean=new ActividadesFormulaMaestra();
            while (res.next()) 
            {
                if(bean.getCodActividadFormula()!=res.getInt("COD_ACTIVIDAD_FORMULA"))
                {
                    if(bean.getCodActividadFormula()>0)
                    {
                        actividadesFormulaMaestraList.add(bean);
                    }
                    bean=new ActividadesFormulaMaestra();
                    bean.getEstadoReferencial().setCodEstadoRegistro(res.getString("COD_ESTADO_REGISTRO"));
                    bean.getEstadoReferencial().setNombreEstadoRegistro(res.getString("NOMBRE_ESTADO_REGISTRO"));
                    bean.setCodActividadFormula(res.getInt("COD_ACTIVIDAD_FORMULA"));
                    bean.setOrdenActividad(res.getInt("ORDEN_ACTIVIDAD"));
                    bean.getActividadesProduccion().setCodActividad(res.getInt("COD_ACTIVIDAD"));
                    bean.getActividadesProduccion().setNombreActividad(res.getString("NOMBRE_ACTIVIDAD"));
                    bean.getActividadesProduccion().getProcesosOrdenManufactura().setCodProcesoOrdenManufactura(res.getInt("COD_PROCESO_ORDEN_MANUFACTURA"));
                    bean.getActividadesProduccion().getProcesosOrdenManufactura().setNombreProcesoOrdenManufactura(res.getString("NOMBRE_PROCESO_ORDEN_MANUFACTURA"));
                    bean.getFormulaMaestra().setCodFormulaMaestra(res.getString("COD_FORMULA_MAESTRA"));
                    bean.getAreasEmpresa().setCodAreaEmpresa(res.getString("COD_AREA_EMPRESA"));
                    bean.getAreasEmpresa().setNombreAreaEmpresa(res.getString("NOMBRE_AREA_EMPRESA"));
                    bean.getTiposProgramaProduccion().setCodTipoProgramaProd(res.getString("COD_TIPO_PROGRAMA_PROD"));
                    bean.getTiposProgramaProduccion().setNombreTipoProgramaProd(res.getString("NOMBRE_TIPO_PROGRAMA_PROD"));
                    bean.getPresentacionesProducto().setCodPresentacion(res.getString("COD_PRESENTACION"));
                    bean.getPresentacionesProducto().setNombreProductoPresentacion(res.getString("NOMBRE_PRODUCTO_PRESENTACION"));
                    bean.getActividadFormulaMaestraBloque().setCodActividadFormulaMaestraBloque(res.getInt("COD_ACTIVIDAD_FORMULA_MAESTRA_BLOQUE"));
                    bean.setActividadesFormulaMaestraHorasEstandarMaquinariaList(new ArrayList<ActividadesFormulaMaestraHorasEstandarMaquinaria>());
                }
                
                ActividadesFormulaMaestraHorasEstandarMaquinaria detalle=new ActividadesFormulaMaestraHorasEstandarMaquinaria();
                detalle.setCodActividadesFormulaMaestraHorasEstandarMaquinaria(res.getInt("COD_ACTIVIDADES_FORMULA_MAESTRA_HORAS_ESTANDAR_MAQUINARIA"));
                detalle.getMaquinaria().setCodMaquina(res.getString("COD_MAQUINA"));
                detalle.getMaquinaria().setCodigo(res.getString("CODIGO"));
                detalle.getMaquinaria().setNombreMaquina(res.getString("NOMBRE_MAQUINA"));
                detalle.setHorasHombreEstandar(res.getDouble("HORAS_HOMBRE_ESTANDAR"));
                detalle.setHorasMaquinaEstandar(res.getDouble("HORAS_MAQUINA_ESTANDAR"));
                bean.getActividadesFormulaMaestraHorasEstandarMaquinariaList().add(detalle);
                   
            }
            if(bean.getCodActividadFormula()>0)
            {
                actividadesFormulaMaestraList.add(bean);
            }
            
        } catch (SQLException ex) {
            LOGGER.warn(ex.getMessage());
        } catch (NumberFormatException ex) {
            LOGGER.warn(ex.getMessage());
        } finally {
            this.cerrarConexion(con);
        }
        return actividadesFormulaMaestraList;
    }
    
    public boolean modificar(ActividadesFormulaMaestra actividadesFormulaMaestra)throws SQLException
    {
        boolean transaccionExitosa=false;
        try 
        {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta = new StringBuilder("UPDATE ACTIVIDADES_FORMULA_MAESTRA  ");
                                    consulta.append(" SET COD_ACTIVIDAD = ").append(actividadesFormulaMaestra.getActividadesProduccion().getCodActividad());
                                            consulta.append("  ,ORDEN_ACTIVIDAD = ").append(actividadesFormulaMaestra.getOrdenActividad());
                                            consulta.append("  ,COD_AREA_EMPRESA = ").append(actividadesFormulaMaestra.getAreasEmpresa().getCodAreaEmpresa());
                                            consulta.append("  ,COD_ESTADO_REGISTRO = ").append(actividadesFormulaMaestra.getEstadoReferencial().getCodEstadoRegistro());
                                            consulta.append("  ,COD_PRESENTACION =").append(actividadesFormulaMaestra.getPresentacionesProducto().getCodPresentacion());
                                            consulta.append(" ,COD_TIPO_PROGRAMA_PROD = ").append(actividadesFormulaMaestra.getTiposProgramaProduccion().getCodTipoProgramaProd());
                                    consulta.append(" WHERE COD_ACTIVIDAD_FORMULA = ").append(actividadesFormulaMaestra.getCodActividadFormula());
            LOGGER.debug("consulta editar actividad formula maestra "+consulta.toString());   
            PreparedStatement pst = con.prepareStatement(consulta.toString());
            if (pst.executeUpdate() > 0) LOGGER.info("se edito la actividad formula maestra");
            if(actividadesFormulaMaestra.getActividadesFormulaMaestraHorasEstandarMaquinariaList()!=null)
            {
                consulta=new StringBuilder("DELETE ACTIVIDADES_FORMULA_MAESTRA_HORAS_ESTANDAR_MAQUINARIA ");
                            consulta.append(" where COD_ACTIVIDAD_FORMULA=").append(actividadesFormulaMaestra.getCodActividadFormula());
                LOGGER.debug("consulta eliminar horas estandar actividad "+consulta.toString());
                pst=con.prepareStatement(consulta.toString());
                if(pst.executeUpdate()>0)LOGGER.info("se eliminaron las horas estandar");
                
                consulta=new StringBuilder("INSERT INTO ACTIVIDADES_FORMULA_MAESTRA_HORAS_ESTANDAR_MAQUINARIA(COD_MAQUINA,COD_ACTIVIDAD_FORMULA, HORAS_MAQUINA_ESTANDAR, HORAS_HOMBRE_ESTANDAR)");
                            consulta.append(" VALUES (");
                                    consulta.append("?,");//cod maquinaria
                                    consulta.append(actividadesFormulaMaestra.getCodActividadFormula()).append(",");
                                    consulta.append("?,");//horas maquina estandar
                                    consulta.append("?");//horas hombre estandar
                            consulta.append(");");
                LOGGER.debug("consulta registrar actividad hora estandar pstam"+consulta.toString());
                pst=con.prepareStatement(consulta.toString());
                for(ActividadesFormulaMaestraHorasEstandarMaquinaria bean: actividadesFormulaMaestra.getActividadesFormulaMaestraHorasEstandarMaquinariaList())
                {
                    pst.setString(1,bean.getMaquinaria().getCodMaquina());LOGGER.info("p1 pstam: "+bean.getMaquinaria().getCodMaquina());
                    pst.setDouble(2,bean.getHorasMaquinaEstandar());LOGGER.info("p2 pstam: "+bean.getHorasMaquinaEstandar());
                    pst.setDouble(3,bean.getHorasHombreEstandar());LOGGER.info("p3 pstam: "+bean.getHorasHombreEstandar());
                    if(pst.executeUpdate()>0)LOGGER.info("se registro el detalle maquinaria actividad");
                }
            }
            con.commit();
            transaccionExitosa=true;
            pst.close();
        } 
        catch (SQLException ex) 
        {
            transaccionExitosa=false;
            LOGGER.warn(ex.getMessage());
            con.rollback();
        }
        catch (NumberFormatException ex) 
        {
            transaccionExitosa=false;
            LOGGER.warn(ex.getMessage());
            con.rollback();
        }
        finally 
        {
            con.close();
        }
        return transaccionExitosa;
    }
    
    
    public boolean guardar(ActividadesFormulaMaestra actividadesFormulaMaestra)throws SQLException
    {
        boolean transaccionExitosa=false;
        try 
        {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta = new StringBuilder("INSERT INTO ACTIVIDADES_FORMULA_MAESTRA(COD_FORMULA_MAESTRA, COD_ACTIVIDAD, ORDEN_ACTIVIDAD, COD_AREA_EMPRESA,COD_ESTADO_REGISTRO, COD_PRESENTACION,COD_TIPO_PROGRAMA_PROD)");
                                    consulta.append(" VALUES (");
                                            consulta.append(actividadesFormulaMaestra.getFormulaMaestra().getCodFormulaMaestra()).append(",");
                                            consulta.append(actividadesFormulaMaestra.getActividadesProduccion().getCodActividad()).append(",");
                                                    consulta.append("(select isnull(max(afm.ORDEN_ACTIVIDAD),0)+1 ");
                                                    consulta.append(" from ACTIVIDADES_FORMULA_MAESTRA afm");
                                                            consulta.append(" where afm.COD_ESTADO_REGISTRO=1 ");
                                                            consulta.append(" and afm.COD_FORMULA_MAESTRA=").append(actividadesFormulaMaestra.getFormulaMaestra().getCodFormulaMaestra());
                                                            consulta.append(" and afm.COD_AREA_EMPRESA=").append(actividadesFormulaMaestra.getAreasEmpresa().getCodAreaEmpresa());
                                                            consulta.append(" and afm.COD_TIPO_PROGRAMA_PROD=").append(actividadesFormulaMaestra.getTiposProgramaProduccion().getCodTipoProgramaProd());
                                                            consulta.append(" and afm.COD_PRESENTACION=").append(actividadesFormulaMaestra.getPresentacionesProducto().getCodPresentacion()).append("),");
                                            consulta.append(actividadesFormulaMaestra.getAreasEmpresa().getCodAreaEmpresa()).append(",");
                                            consulta.append(actividadesFormulaMaestra.getEstadoReferencial().getCodEstadoRegistro()).append(",");
                                            consulta.append(actividadesFormulaMaestra.getPresentacionesProducto().getCodPresentacion()).append(",");
                                            consulta.append(actividadesFormulaMaestra.getTiposProgramaProduccion().getCodTipoProgramaProd());
                                    consulta.append(")");
            LOGGER.debug("consulta registrar actividad formula maestra " +consulta.toString());
            PreparedStatement pst = con.prepareStatement(consulta.toString(),PreparedStatement.RETURN_GENERATED_KEYS);
            if (pst.executeUpdate() > 0) LOGGER.info("se actualizo la actividad formula maestra");
            ResultSet res=pst.getGeneratedKeys();
            res.next();
            consulta=new StringBuilder("INSERT INTO ACTIVIDADES_PROGRAMA_PRODUCCION(COD_ACTIVIDAD_PROGRAMA,COD_FORMULA_MAESTRA, COD_ACTIVIDAD, ORDEN_ACTIVIDAD, COD_ESTADO_ACTIVIDAD)");
                        consulta.append(" VALUES (");
                                consulta.append(res.getInt(1)).append(",");
                                consulta.append(actividadesFormulaMaestra.getFormulaMaestra().getCodFormulaMaestra()).append(",");
                                consulta.append(actividadesFormulaMaestra.getActividadesProduccion().getCodActividad()).append(",");
                                consulta.append(actividadesFormulaMaestra.getOrdenActividad()).append(",");
                                consulta.append(actividadesFormulaMaestra.getEstadoReferencial().getCodEstadoRegistro());
                        consulta.append(")");
            LOGGER.debug("consulta registrar actividad programa produccion "+consulta.toString());
            pst=con.prepareStatement(consulta.toString());
            if(pst.executeUpdate()>0)LOGGER.info("se registro la actividad programa produccion");
            consulta=new StringBuilder("INSERT INTO ACTIVIDADES_FORMULA_MAESTRA_HORAS_ESTANDAR_MAQUINARIA(COD_MAQUINA,COD_ACTIVIDAD_FORMULA, HORAS_MAQUINA_ESTANDAR, HORAS_HOMBRE_ESTANDAR)");
                        consulta.append(" VALUES (");
                                consulta.append("?,");//cod maquinaria
                                consulta.append(res.getInt(1)).append(",");
                                consulta.append("?,");//horas maquina estandar
                                consulta.append("?");//horas hombre estandar
                        consulta.append(");");
            LOGGER.debug("consulta registrar actividad hora estandar pstam"+consulta.toString());
            pst=con.prepareStatement(consulta.toString());
            for(ActividadesFormulaMaestraHorasEstandarMaquinaria bean: actividadesFormulaMaestra.getActividadesFormulaMaestraHorasEstandarMaquinariaList())
            {
                pst.setString(1,bean.getMaquinaria().getCodMaquina());LOGGER.info("p1 pstam: "+bean.getMaquinaria().getCodMaquina());
                pst.setDouble(2,bean.getHorasMaquinaEstandar());LOGGER.info("p2 pstam: "+bean.getHorasMaquinaEstandar());
                pst.setDouble(3,bean.getHorasHombreEstandar());LOGGER.info("p3 pstam: "+bean.getHorasHombreEstandar());
                if(pst.executeUpdate()>0)LOGGER.info("se registro el detalle maquinaria actividad");
            }
            con.commit();
            transaccionExitosa=true;
            pst.close();
        } catch (SQLException ex) {
            con.rollback();
            transaccionExitosa=false;
            LOGGER.warn(ex.getMessage());
        }
        catch (Exception ex) {
            con.rollback();
            transaccionExitosa=false;
            LOGGER.warn(ex.getMessage());
        }
        finally 
        {
            con.close();
        }
        return transaccionExitosa;
    }
    
}
