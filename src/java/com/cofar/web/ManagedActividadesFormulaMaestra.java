
/*
 * ManagedCartonesCorrugados.java
 * Created on 25 de Junio de 2008, 10:50
 */

package com.cofar.web;


import com.cofar.bean.ActividadFormulaMaestraBloque;
import com.cofar.bean.ActividadesFormulaMaestra;
import com.cofar.bean.ActividadesFormulaMaestraHorasEstandarMaquinaria;
import com.cofar.bean.FormulaMaestra;
import com.cofar.bean.MaquinariaActividadesFormula;
import com.cofar.bean.TiposProgramaProduccion;
import com.cofar.dao.DaoActividadFormulaMaestraBloque;
import com.cofar.dao.DaoActividadesFormulaMaestra;
import com.cofar.dao.DaoActividadesProduccion;
import com.cofar.dao.DaoComponentesPresProd;
import com.cofar.dao.DaoTiposProgramaProduccion;
import com.cofar.util.Util;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import javax.faces.model.SelectItem;
import org.apache.logging.log4j.LogManager;

/**
 *
 *  @author Jose Quispe
 *  @company COFAR
 */
public class ManagedActividadesFormulaMaestra extends ManagedBean
{
    
    
    Connection con;
    private List<SelectItem> actividadesProduccionGestionarSelectList;
    private List<SelectItem> maquinariasSelectList;
    private List<SelectItem> tiposProgramaProduccionSelectList;
    private List<SelectItem> presentacionesProductoSelectList;
    private List<SelectItem> actividadesProduccionSelectList;
    
    //variable para editar o registrar una nueva actividad
    private ActividadesFormulaMaestra actividadesFormulaMaestraGestionar;
    
    private ActividadFormulaMaestraBloque actividadFormulaMaestraBloqueGestionar;
    
    private String mensaje="";
    private List<FormulaMaestra> formulaMaestraList;
    private FormulaMaestra formulaMaestraBuscar=new FormulaMaestra();
    private FormulaMaestra formulaMaestraSeleccionada;
    private List<SelectItem> tiposProduccionSelectList;
    private List<SelectItem> estadosCompProdSelectList;
    private List<SelectItem> areasEmpresaSelectList;
    
    
    private List<SelectItem> areasEmpresaActividadSelectList;
    
    private List<ActividadFormulaMaestraBloque> actividadFormulaMaestraBloqueList;
    private ActividadesFormulaMaestra actividadesFormulaMaestraBuscar;
    
    private List<ActividadesFormulaMaestra> actividadesFormulaMaestraAgregarList;
    private ActividadesFormulaMaestra actividadesFormulaMaestraEditar;
    
    private MaquinariaActividadesFormula maquinariaActividadesFormulaAgregarGeneral;
    private ActividadesFormulaMaestra actividadesFormulaMaestraGeneral;
    
    
    private List<ActividadesFormulaMaestra> actividadesFMAdicionarGeneralList;
    private List<SelectItem> formasFarmaceuticasSelectList;
    private ActividadesFormulaMaestra actividadesFMAdicionarGeneral=new ActividadesFormulaMaestra();
    
    // <editor-fold defaultstate="collapsed" desc="gestionar actividades">
        public String codAreaEmpresaActividadFormulaBuscar_change()
        {
            actividadesFormulaMaestraBuscar.getTiposProgramaProduccion().setCodTipoProgramaProd("0");
            actividadesFormulaMaestraBuscar.getPresentacionesProducto().setCodPresentacion("0");
            return null;
        }
        public String modificarActividadFormulaMaestra_action()throws SQLException
        {
            transaccionExitosa=false;
            DaoActividadesFormulaMaestra daoActividadesFormulaMaestra=new DaoActividadesFormulaMaestra();
            if(daoActividadesFormulaMaestra.modificar(actividadesFormulaMaestraGestionar))
            {
                this.mostrarMensajeTransaccionExitosa("Se registro satisfactoriamente la edicion de la actividad");
            }
            else
            {
                this.mostrarMensajeTransaccionFallida("Ocurrio un error al momento de modificar la actividad, intente de nuevo");
            }
            if(transaccionExitosa)
            {
                this.cargarActividadesFormulaMaestraList();
            }
            return null;
        }
        public String seleccionarEditarActividadFormulaMaestra_action()
        {
            this.cargarMaquinariasSelectList();
            if(actividadesFormulaMaestraGestionar.getActividadesFormulaMaestraHorasEstandarMaquinariaList().size()>0
                    && actividadesFormulaMaestraGestionar.getActividadesFormulaMaestraHorasEstandarMaquinariaList().get(0).getCodActividadesFormulaMaestraHorasEstandarMaquinaria()==0)
            {
                actividadesFormulaMaestraGestionar.setActividadesFormulaMaestraHorasEstandarMaquinariaList(new ArrayList<ActividadesFormulaMaestraHorasEstandarMaquinaria>());
            }
            return null;
        }
        public String actividadFormulaMaestraGestionar_change()
        {
            
            actividadesProduccionGestionarSelectList=(new DaoActividadesProduccion()).listarActividadesProduccionSinActividadFormulaMaestra(actividadesFormulaMaestraGestionar);
            return null;
        }
        private void cargarMaquinariasSelectList()
        {
            try 
            {
                con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("select m.COD_MAQUINA,m.NOMBRE_MAQUINA,m.CODIGO");
                                            consulta.append(" from MAQUINARIAS m");
                                            consulta.append(" where m.COD_ESTADO_REGISTRO=1");
                                            consulta.append(" order by m.NOMBRE_MAQUINA");
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res = st.executeQuery(consulta.toString());
                maquinariasSelectList=new ArrayList<SelectItem>();
                while (res.next()) 
                {
                    maquinariasSelectList.add(new SelectItem(res.getString("COD_MAQUINA"),res.getString("NOMBRE_MAQUINA")+"("+res.getString("CODIGO")+")"));

                }
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
        }
        public String inactivarActividadesFormulaMaestra_action()throws SQLException
        {
            transaccionExitosa=false;
            try {
                con = Util.openConnection(con);
                con.setAutoCommit(false);
                StringBuilder codigosActividad=new StringBuilder("");
                
                for(ActividadFormulaMaestraBloque  bean:actividadFormulaMaestraBloqueList)
                {
                    for(ActividadesFormulaMaestra  actividad:bean.getActividadesFormulaMaestraList())
                    {
                        if(actividad.getChecked())
                        {
                            codigosActividad.append(actividad.getCodActividadFormula()).append(",");
                        }
                    }
                }
                StringBuilder consulta = new StringBuilder("update ACTIVIDADES_FORMULA_MAESTRA ");
                                            consulta.append(" SET COD_ESTADO_REGISTRO=2");
                                            consulta.append(" WHERE COD_ACTIVIDAD_FORMULA IN (");
                                                    consulta.append(codigosActividad.toString()).append("-1");
                                            consulta.append(")");
                LOGGER.debug("consulta inactivar actividad  formula "+consulta.toString());
                PreparedStatement pst = con.prepareStatement(consulta.toString());
                if(pst.executeUpdate()>0)LOGGER.info("se inactivaron las actividades");
                con.commit();
                this.mostrarMensajeTransaccionExitosa("Se inactivaron "+codigosActividad.toString().split(",").length+" actividades");
                pst.close();
            }catch (SQLException ex) {
                this.mostrarMensajeTransaccionFallida("Ocurrio un error de datos al momento de inactivar las actividades, verifique la información e intente de nuevo");
                LOGGER.warn(ex.getMessage());
                con.rollback();
            } catch (NumberFormatException ex) {
                this.mostrarMensajeTransaccionFallida("Ocurrio un error de datos al momento de inactivar las actividades, verifique la información e intente de nuevo");
                LOGGER.warn(ex.getMessage());
                con.rollback();
            } finally {
                this.cerrarConexion(con);
            }
            if(transaccionExitosa)
            {
                this.cargarActividadesFormulaMaestraList();
            }
            return null;
        }
        public String agregarActividadFormulaMaestra_action()
        {
            this.cargarMaquinariasSelectList();
            
            actividadesFormulaMaestraGestionar=new ActividadesFormulaMaestra();
            actividadesFormulaMaestraGestionar.setActividadesFormulaMaestraHorasEstandarMaquinariaList(new ArrayList<ActividadesFormulaMaestraHorasEstandarMaquinaria>());
            actividadesFormulaMaestraGestionar.getFormulaMaestra().setCodFormulaMaestra("0");
            actividadesFormulaMaestraGestionar.getTiposProgramaProduccion().setCodTipoProgramaProd("0");
            actividadesFormulaMaestraGestionar.getPresentacionesProducto().setCodPresentacion("0");
            actividadesFormulaMaestraGestionar.getAreasEmpresa().setCodAreaEmpresa("96");
            actividadesFormulaMaestraGestionar.getEstadoReferencial().setCodEstadoRegistro("1");
            actividadesFormulaMaestraGestionar.setFormulaMaestra(formulaMaestraSeleccionada);
            this.actividadFormulaMaestraGestionar_change();
            return null;
        }
        public String agregarActividadFormulaMaestraGestionarHorasEstandar_action()
        {
            actividadesFormulaMaestraGestionar.getActividadesFormulaMaestraHorasEstandarMaquinariaList().add(new ActividadesFormulaMaestraHorasEstandarMaquinaria());
            return null;
        }
        public String eliminarActividadFormulaMaestraGestionarHorasEstandar_action(ActividadesFormulaMaestraHorasEstandarMaquinaria actividadesFormulaMaestraHorasEstandarMaquinariaEliminar)
        {
            actividadesFormulaMaestraGestionar.getActividadesFormulaMaestraHorasEstandarMaquinariaList().remove(actividadesFormulaMaestraHorasEstandarMaquinariaEliminar);
            return null;
        }
        public String eliminarActividadFormulaMaestra_action(int codActividadFormulaMaestra)throws SQLException
        {
            transaccionExitosa=false;
            DaoActividadesFormulaMaestra daoActividadesFormulaMaestra=new DaoActividadesFormulaMaestra();
            if(daoActividadesFormulaMaestra.cantidadRegistrosRelacionados(codActividadFormulaMaestra)>0)
            {
                this.mostrarMensajeTransaccionFallida("No se puede eliminar la actividad porque ya cuenta con registros dependientes");
            }
            else
            {
                if(daoActividadesFormulaMaestra.eliminar(codActividadFormulaMaestra))
                {
                    this.mostrarMensajeTransaccionExitosa("Se elimino satisfactoriamente la actividad");
                }
                else
                {
                    this.mostrarMensajeTransaccionFallida("Ocurrio un error al momento de eliminar la actividad, intente de nuevo");
                }
            }
            if(transaccionExitosa)
            {
                this.cargarActividadesFormulaMaestraList();
            }
            return null;
        }
        public String guardarActividadFormulaMaestra_action()throws SQLException
        {
            transaccionExitosa=false;
            DaoActividadesFormulaMaestra daoActividadesFormulaMaestra=new DaoActividadesFormulaMaestra();
            if(daoActividadesFormulaMaestra.guardar(actividadesFormulaMaestraGestionar))
            {
                this.mostrarMensajeTransaccionExitosa("Se registro satisfactoriamente la actividad");
            }
            else
            {
                this.mostrarMensajeTransaccionFallida("Ocurrio un error el momento de registrar la transaccion");
            }
            if(transaccionExitosa)
            {
                this.cargarActividadesFormulaMaestraList();
            }
            return null;
        }
    
    
    //</editor-fold>
        
    // <editor-fold defaultstate="collapsed" desc="gestionar bloques de actividad">
        public String seleccionarEditarActividadFormulaMaestraBloque_action()
        {
            DaoActividadesFormulaMaestra daoActividadesFormulaMaestra=new DaoActividadesFormulaMaestra();
            actividadFormulaMaestraBloqueGestionar.setActividadesFormulaMaestraList(daoActividadesFormulaMaestra.listar(actividadFormulaMaestraBloqueGestionar.getActividadesFormulaMaestraList().get(0)));
            for(ActividadesFormulaMaestra bean:actividadFormulaMaestraBloqueGestionar.getActividadesFormulaMaestraList()){
                bean.setChecked(true);
            }
            actividadFormulaMaestraBloqueGestionar.getActividadesFormulaMaestraList().addAll(daoActividadesFormulaMaestra.listarNoAsociadasABloque(actividadFormulaMaestraBloqueGestionar.getActividadesFormulaMaestraList().get(0)));
            return null;
        }
        public String agregarActividadFormulaMaestraBloque_action()
        {
            actividadFormulaMaestraBloqueGestionar=new ActividadFormulaMaestraBloque();
            DaoActividadesFormulaMaestra daoActividadesFormulaMaestra=new DaoActividadesFormulaMaestra();
            actividadFormulaMaestraBloqueGestionar.setActividadesFormulaMaestraList(daoActividadesFormulaMaestra.listarNoAsociadasABloque(actividadFormulaMaestraBloqueList.get(0).getActividadesFormulaMaestraList().get(0)));
            return null;
        }
        public String eliminarActividadFormulaMaestraBloque_action(int codActividadFormulaMaestraBloque)throws SQLException
        {
            DaoActividadFormulaMaestraBloque daoActividadFormulaMaestraBloque=new DaoActividadFormulaMaestraBloque();
            if(daoActividadFormulaMaestraBloque.eliminar(codActividadFormulaMaestraBloque))
            {
                this.mostrarMensajeTransaccionExitosa("Se elimino el bloque de actividades");
            }
            else
            {
                this.mostrarMensajeTransaccionFallida("Ocurrio un error al momento de registrar la transacción");
            }
            if(transaccionExitosa)
            {
                this.cargarActividadesFormulaMaestraList();
            }
            return null;
        }
        
        public String modificarActividadFormulaMaestraBloque_action()throws SQLException
        {
            transaccionExitosa=false;
            int contadorRegistrosSeleccionados=0;
            // <editor-fold defaultstate="collapsed" desc="cantidad registros">
                for(ActividadesFormulaMaestra bean:actividadFormulaMaestraBloqueGestionar.getActividadesFormulaMaestraList())
                {
                    contadorRegistrosSeleccionados+=bean.getChecked()?1:0;
                }
            //</editor-fold>
            if(contadorRegistrosSeleccionados>0)
            {
                // <editor-fold defaultstate="collapsed" desc="quitando actividades no seleccionadas">
                    for(int i=actividadFormulaMaestraBloqueGestionar.getActividadesFormulaMaestraList().size()-1;
                            i>=0;i--)
                    {
                        if(!actividadFormulaMaestraBloqueGestionar.getActividadesFormulaMaestraList().get(i).getChecked())
                        {
                            actividadFormulaMaestraBloqueGestionar.getActividadesFormulaMaestraList().remove(i);
                        }
                    }
                //</editor-fold>
                DaoActividadFormulaMaestraBloque daoActividadFormulaMaestraBloque=new DaoActividadFormulaMaestraBloque();
                if(daoActividadFormulaMaestraBloque.modificar(actividadFormulaMaestraBloqueGestionar))
                {
                    this.mostrarMensajeTransaccionExitosa("Se registro satisfactoriamente la transacción");
                }
                else
                {
                    this.mostrarMensajeTransaccionFallida("Ocurrio un error al momento de registrar la transacción");
                }
                
            }
            else
            {
                this.mostrarMensajeTransaccionFallida("No selecciono ninguna actividad para el bloque");
            }
            if(transaccionExitosa)
            {
                this.cargarActividadesFormulaMaestraList();
            }
            return null;
        }
        public String guardarActividadFormulaMaestraBloque_action()throws SQLException
        {
            transaccionExitosa=false;
            int contadorRegistrosSeleccionados=0;
            // <editor-fold defaultstate="collapsed" desc="cantidad registros">
                for(ActividadesFormulaMaestra bean:actividadFormulaMaestraBloqueGestionar.getActividadesFormulaMaestraList())
                {
                    contadorRegistrosSeleccionados+=bean.getChecked()?1:0;
                }
            //</editor-fold>
            if(contadorRegistrosSeleccionados>0)
            {
                // <editor-fold defaultstate="collapsed" desc="quitando actividades no seleccionadas">
                    for(int i=actividadFormulaMaestraBloqueGestionar.getActividadesFormulaMaestraList().size()-1;
                            i>=0;i--)
                    {
                        if(!actividadFormulaMaestraBloqueGestionar.getActividadesFormulaMaestraList().get(i).getChecked())
                        {
                            actividadFormulaMaestraBloqueGestionar.getActividadesFormulaMaestraList().remove(i);
                        }
                    }
                //</editor-fold>
                DaoActividadFormulaMaestraBloque daoActividadFormulaMaestraBloque=new DaoActividadFormulaMaestraBloque();
                if(daoActividadFormulaMaestraBloque.guardar(actividadFormulaMaestraBloqueGestionar))
                {
                    this.mostrarMensajeTransaccionExitosa("Se registro satisfactoriamente la transacción");
                }
                else
                {
                    this.mostrarMensajeTransaccionFallida("Ocurrio un error al momento de registrar la transacción");
                }
            }
            else
            {
                this.mostrarMensajeTransaccionFallida("No selecciono ninguna actividad para el bloque");
            }
            if(transaccionExitosa)
            {
                this.cargarActividadesFormulaMaestraList();
            }
            return null;
        }
    //</editor-fold>
    
    
    // <editor-fold defaultstate="collapsed" desc="variables para duplicar actividades">
        private List<ActividadesFormulaMaestra> actividadesFormulaMaestraDuplicarList=new ArrayList<ActividadesFormulaMaestra>();
        private ActividadesFormulaMaestra actividadesFormulaMaestraDuplicar=new ActividadesFormulaMaestra();
        private ActividadesFormulaMaestra actividadesFormulaMaestraDestino=new ActividadesFormulaMaestra();
        private String codAreaEmpresa="";
        private List<SelectItem> presentacionesSelectList;
        private List<SelectItem> presentacionesDestinoSelectList;
        private List<SelectItem> formulaMaestraSelectList;
        private boolean  eliminarDatosActividadesDestino=false;
        private boolean  productosConPresentaciones=true;
    //</editor-fold>
    
    
    // <editor-fold defaultstate="collapsed" desc="navegador formula maestra">
        public ManagedActividadesFormulaMaestra() 
        {
            LOGGER=LogManager.getRootLogger();
            formulaMaestraBuscar.getComponentesProd().getEstadoCompProd().setCodEstadoCompProd(1);
            formulaMaestraBuscar.getComponentesProd().getAreasEmpresa().setCodAreaEmpresa("0");
            formulaMaestraBuscar.getComponentesProd().getTipoProduccion().setCodTipoProduccion(1);
        }

        

        public String getCargarFormulaMaestra()
        {
            areasEmpresaActividadSelectList=new ArrayList<SelectItem>();
            actividadesProduccionSelectList=new ArrayList<SelectItem>();
            this.cargarFormulasMaestraList();
            this.cargarTiposProduccionSelectList();
            this.cargarEstadosCompProdSelectList();
            this.cargarAreasEmpresaSelectList();
            
            return null;
        }
        public String buscarFormulaMaestra_action()
        {
            this.cargarFormulasMaestraList();
            return null;
        }
        private void cargarFormulasMaestraList()
        {
            try 
            {
                con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("select fm.COD_FORMULA_MAESTRA,cp.COD_COMPPROD,cp.nombre_prod_semiterminado,fm.CANTIDAD_LOTE,tp.NOMBRE_TIPO_PRODUCCION,ec.NOMBRE_ESTADO_COMPPROD");
                                                    consulta.append(" ,ae.NOMBRE_AREA_EMPRESA,ae.COD_AREA_EMPRESA");
                                            consulta.append(" from FORMULA_MAESTRA fm ");
                                                    consulta.append(" inner join COMPONENTES_PROD cp on cp.COD_COMPPROD=fm.COD_COMPPROD");
                                                    consulta.append(" inner join ESTADOS_COMPPROD ec on ec.COD_ESTADO_COMPPROD=cp.COD_ESTADO_COMPPROD");
                                                    consulta.append(" inner join TIPOS_PRODUCCION tp on tp.COD_TIPO_PRODUCCION=cp.COD_TIPO_PRODUCCION");
                                                    consulta.append(" inner join AREAS_EMPRESA ae on ae.COD_AREA_EMPRESA=cp.COD_AREA_EMPRESA");
                                            consulta.append(" where  fm.COD_ESTADO_REGISTRO=cp.COD_ESTADO_COMPPROD");
                                                    if(formulaMaestraBuscar.getComponentesProd().getEstadoCompProd().getCodEstadoCompProd() > 0)
                                                        consulta.append(" and cp.COD_ESTADO_COMPPROD=").append(formulaMaestraBuscar.getComponentesProd().getEstadoCompProd().getCodEstadoCompProd());
                                                    if(!formulaMaestraBuscar.getComponentesProd().getAreasEmpresa().getCodAreaEmpresa().equals("0"))
                                                            consulta.append(" and cp.COD_AREA_EMPRESA=").append(formulaMaestraBuscar.getComponentesProd().getAreasEmpresa().getCodAreaEmpresa());
                                                    if(formulaMaestraBuscar.getComponentesProd().getTipoProduccion().getCodTipoProduccion()>0)
                                                            consulta.append(" and cp.COD_TIPO_PRODUCCION=").append(formulaMaestraBuscar.getComponentesProd().getTipoProduccion().getCodTipoProduccion());
                                                    if(formulaMaestraBuscar.getComponentesProd().getNombreProdSemiterminado().length()>0)
                                                            consulta.append(" and cp.nombre_prod_semiterminado like '%").append(formulaMaestraBuscar.getComponentesProd().getNombreProdSemiterminado()).append("%'");
                                            consulta.append(" order by cp.nombre_prod_semiterminado");
                LOGGER.debug(" consulta cargar formulas  maestras "+consulta.toString());
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res = st.executeQuery(consulta.toString());
                formulaMaestraList=new ArrayList<FormulaMaestra>();
                while (res.next()) 
                {
                    FormulaMaestra nuevo=new FormulaMaestra();
                    nuevo.getComponentesProd().setNombreProdSemiterminado(res.getString("nombre_prod_semiterminado"));
                    nuevo.getComponentesProd().setCodCompprod(res.getString("COD_COMPPROD"));
                    nuevo.setCodFormulaMaestra(res.getString("COD_FORMULA_MAESTRA"));
                    nuevo.setCantidadLote(res.getDouble("CANTIDAD_LOTE"));
                    nuevo.getComponentesProd().getTipoProduccion().setNombreTipoProduccion(res.getString("NOMBRE_TIPO_PRODUCCION"));
                    nuevo.getComponentesProd().getEstadoCompProd().setNombreEstadoCompProd(res.getString("NOMBRE_ESTADO_COMPPROD"));
                    nuevo.getComponentesProd().getAreasEmpresa().setCodAreaEmpresa(res.getString("COD_AREA_EMPRESA"));
                    nuevo.getComponentesProd().getAreasEmpresa().setNombreAreaEmpresa(res.getString("NOMBRE_AREA_EMPRESA"));
                    formulaMaestraList.add(nuevo);

                }
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
        }
    //</editor-fold>
    
    // <editor-fold defaultstate="collapsed" desc="funciones cargar listas select">
        
    private void cargarFormasFarmaceuticasSelect_action()
     {
         try
         {
             con=Util.openConnection(con);
             Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
             StringBuilder consulta=new StringBuilder(" select f.cod_forma,f.nombre_forma");
                                        consulta.append(" from FORMAS_FARMACEUTICAS f");
                                        consulta.append(" where f.cod_estado_registro=1");
                                        consulta.append(" order by f.nombre_forma");
            LOGGER.debug("consutla cargar formas select "+consulta.toString());
             ResultSet res=st.executeQuery(consulta.toString());
             formasFarmaceuticasSelectList=new ArrayList<SelectItem>();
             while(res.next())
             {
                 formasFarmaceuticasSelectList.add(new SelectItem(res.getString("cod_forma"),res.getString("nombre_forma")));
             }
             st.close();
             
         }
         catch(SQLException ex)
         {
             LOGGER.warn("error", ex);
         }
         finally
         {
             this.cerrarConexion(con);
         }
     }
    
    private void cargarComponentesProdSelect()
    {
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select  fm.COD_FORMULA_MAESTRA,cp.nombre_prod_semiterminado,fm.CANTIDAD_LOTE");
                                        consulta.append(" from FORMULA_MAESTRA fm");
                                                consulta.append(" inner join COMPONENTES_PROD cp on cp.COD_COMPPROD=fm.COD_COMPPROD");
                                        
                                        consulta.append(" order by cp.nombre_prod_semiterminado");
            LOGGER.debug("consulta productos "+consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            formulaMaestraSelectList=new ArrayList<SelectItem>();
            while (res.next()) {
                formulaMaestraSelectList.add(new SelectItem(res.getString("COD_FORMULA_MAESTRA"),res.getString("nombre_prod_semiterminado")+"("+res.getString("CANTIDAD_LOTE")+")"));
            }
            st.close();
        } catch (SQLException ex) {
            LOGGER.warn("error", ex);
        } finally {
            this.cerrarConexion(con);
        }
    }    
        
    
    private void cargarActividadesProduccionSelectList()
    {
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select ap.COD_ACTIVIDAD,ap.NOMBRE_ACTIVIDAD");
                                        consulta.append(" from ACTIVIDADES_PRODUCCION ap where ap.COD_ESTADO_REGISTRO=1");
                                        consulta.append(" order by ap.NOMBRE_ACTIVIDAD");
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            actividadesProduccionSelectList=new ArrayList<SelectItem>();
            while (res.next()) 
            {
                actividadesProduccionSelectList.add(new SelectItem(res.getInt("COD_ACTIVIDAD"),res.getString("NOMBRE_ACTIVIDAD")));
                
            }
            st.close();
        } catch (SQLException ex) {
            LOGGER.warn("error", ex);
        } finally {
            this.cerrarConexion(con);
        }
    }
    private void cargarEstadosCompProdSelectList()
    {
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select ec.COD_ESTADO_COMPPROD,ec.NOMBRE_ESTADO_COMPPROD");
                                    consulta.append(" from ESTADOS_COMPPROD ec");
                                    consulta.append(" order by ec.NOMBRE_ESTADO_COMPPROD");
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            estadosCompProdSelectList=new ArrayList<SelectItem>();
            while (res.next()) 
            {
                estadosCompProdSelectList.add(new SelectItem(res.getString("COD_ESTADO_COMPPROD"),res.getString("NOMBRE_ESTADO_COMPPROD")));
            }
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
    }
    private void cargarTiposProduccionSelectList()
    {
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select tp.COD_TIPO_PRODUCCION,tp.NOMBRE_TIPO_PRODUCCION");
                                        consulta.append(" from TIPOS_PRODUCCION tp");
                                        consulta.append(" order by tp.NOMBRE_TIPO_PRODUCCION");
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            tiposProduccionSelectList=new ArrayList<SelectItem>();
            while (res.next()) 
            {
                tiposProduccionSelectList.add(new SelectItem(res.getInt("COD_TIPO_PRODUCCION"),res.getString("NOMBRE_TIPO_PRODUCCION")));
            }
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
    }
    private void cargarAreasEmpresaSelectList()
    {
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select ae.COD_AREA_EMPRESA,ae.NOMBRE_AREA_EMPRESA");
                                        consulta.append(" from AREAS_EMPRESA ae ");
                                        consulta.append(" where ae.COD_AREA_EMPRESA in (80,81,82,95)");
                                        consulta.append(" order by ae.NOMBRE_AREA_EMPRESA");
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            areasEmpresaSelectList=new ArrayList<SelectItem>();
            while (res.next()) 
            {
                areasEmpresaSelectList.add(new SelectItem(res.getString("COD_AREA_EMPRESA"),res.getString("NOMBRE_AREA_EMPRESA")));
            }
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
    }
    private void cargarAreasEmpresaActividadSelectList()
    {
        try 
        {
            con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("select a.COD_AREA_EMPRESA,a.NOMBRE_AREA_EMPRESA");
                                            consulta.append(" from areas_empresa a");
                                                    consulta.append(" inner join AREAS_ACTIVIDAD_PRODUCCION aap on aap.COD_AREA_EMPRESA=a.COD_AREA_EMPRESA");
                                                            consulta.append(" and aap.APLICA_REGISTRO_ACTIVIDADES=1");
                                            consulta.append(" order by a.NOMBRE_AREA_EMPRESA asc");
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            areasEmpresaActividadSelectList=new ArrayList<SelectItem>();
            while (res.next()) 
            {
                areasEmpresaActividadSelectList.add(new SelectItem(res.getString("COD_AREA_EMPRESA"),res.getString("NOMBRE_AREA_EMPRESA")));
            }
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
    }
    
    //</editor-fold>    
    
    
    // <editor-fold defaultstate="collapsed" desc="navegador actividades formula maestra">
        private void cargarTiposProgramaProduccionSelectList()
        {
            tiposProgramaProduccionSelectList=(new DaoTiposProgramaProduccion(LOGGER)).listarSelectItem();
        }
        public String getCargarActividadFormulaMaestra()
        {
            // <editor-fold defaultstate="collapsed" desc="inicializando buscador">
                actividadesFormulaMaestraBuscar=new ActividadesFormulaMaestra();
                actividadesFormulaMaestraBuscar.getPresentacionesProducto().setCodPresentacion("0");
                actividadesFormulaMaestraBuscar.getTiposProgramaProduccion().setCodTipoProgramaProd("0");
                actividadesFormulaMaestraBuscar.getEstadoReferencial().setCodEstadoRegistro("1");
                actividadesFormulaMaestraBuscar.getAreasEmpresa().setCodAreaEmpresa("96");
                actividadesFormulaMaestraBuscar.setFormulaMaestra(formulaMaestraSeleccionada);
            //</editor-fold>
            this.cargarTiposProgramaProduccionSelectList();
            presentacionesProductoSelectList=(new DaoComponentesPresProd()).listarComponentesPresProdPorComponentesProd(formulaMaestraSeleccionada.getComponentesProd());
            this.cargarAreasEmpresaActividadSelectList();
            this.cargarActividadesFormulaMaestraList();
            return null;
        }
        public String buscarActividadesFormulaMaestra_action()
        {
            this.cargarActividadesFormulaMaestraList();
            return null;
        }
        private void cargarActividadesFormulaMaestraList()
        {
            DaoActividadesFormulaMaestra daoActividadesFormulaMaestra=new DaoActividadesFormulaMaestra();
            actividadFormulaMaestraBloqueList=daoActividadesFormulaMaestra.listarPorBloque(actividadesFormulaMaestraBuscar);
        }
    //</editor-fold>
    // <editor-fold defaultstate="collapsed" desc="funciones para agregar actividades">
        public String getCargarAgregarActividadProduccion()
        {
            try 
            {
                con = Util.openConnection(con);
                    StringBuilder consulta = new StringBuilder("select ap.NOMBRE_ACTIVIDAD,ap.COD_ACTIVIDAD");
                                        consulta.append(" from ACTIVIDADES_PRODUCCION ap ");
                                        consulta.append(" where ap.COD_ESTADO_REGISTRO=1");
                                                consulta.append(" and ap.COD_ACTIVIDAD not in");
                                                        consulta.append(" (");
                                                                consulta.append(" select afm.COD_ACTIVIDAD");
                                                                consulta.append(" from ACTIVIDADES_FORMULA_MAESTRA afm ");
                                                                consulta.append(" where afm.COD_FORMULA_MAESTRA=").append(formulaMaestraSeleccionada.getCodFormulaMaestra());
                                                                consulta.append(" and isnull(afm.COD_PRESENTACION,0)=").append(actividadesFormulaMaestraBuscar.getPresentacionesProducto().getCodPresentacion());
                                                                consulta.append(" and afm.COD_AREA_EMPRESA=").append(actividadesFormulaMaestraBuscar.getAreasEmpresa().getCodAreaEmpresa());
                                                        consulta.append(" )");
                                        consulta.append(" order by ap.NOMBRE_ACTIVIDAD");
                LOGGER.debug("consulta cargar actividades no presentes "+consulta.toString());
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res = st.executeQuery(consulta.toString());
                actividadesFormulaMaestraAgregarList=new ArrayList<ActividadesFormulaMaestra>();
                while (res.next()) 
                {
                    ActividadesFormulaMaestra nuevo=new ActividadesFormulaMaestra();
                    nuevo.getActividadesProduccion().setCodActividad(res.getInt("COD_ACTIVIDAD"));
                    nuevo.getActividadesProduccion().setNombreActividad(res.getString("NOMBRE_ACTIVIDAD"));
                    actividadesFormulaMaestraAgregarList.add(nuevo);
                }
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
            return null;
        }
        public String guardarAgregarActividadProduccion_action()throws SQLException
        {
            mensaje = "";
            try 
            {
                con = Util.openConnection(con);
                con.setAutoCommit(false);
                StringBuilder consulta = new StringBuilder("INSERT INTO ACTIVIDADES_FORMULA_MAESTRA(COD_FORMULA_MAESTRA, COD_ACTIVIDAD,ORDEN_ACTIVIDAD, COD_AREA_EMPRESA, COD_ESTADO_REGISTRO, COD_PRESENTACION)");
                                            consulta.append(" VALUES (");
                                                    consulta.append(formulaMaestraSeleccionada.getCodFormulaMaestra()).append(",");
                                                    consulta.append("?,");//codigo de actividad
                                                    consulta.append("?,");//orden actividad
                                                    consulta.append(actividadesFormulaMaestraBuscar.getAreasEmpresa().getCodAreaEmpresa()).append(",");
                                                    consulta.append("1,");
                                                    consulta.append(actividadesFormulaMaestraBuscar.getPresentacionesProducto().getCodPresentacion());
                                            consulta.append(")");
                LOGGER.debug("consulta pst registrar actividad formula " + consulta.toString());
                PreparedStatement pst = con.prepareStatement(consulta.toString(),PreparedStatement.RETURN_GENERATED_KEYS);
                
                consulta=new StringBuilder("INSERT INTO ACTIVIDADES_PROGRAMA_PRODUCCION(COD_FORMULA_MAESTRA, COD_ACTIVIDAD, ORDEN_ACTIVIDAD, COD_ESTADO_ACTIVIDAD,COD_ACTIVIDAD_PROGRAMA)");
                            consulta.append("VALUES (");
                                    consulta.append(formulaMaestraSeleccionada.getCodFormulaMaestra()).append(",");
                                    consulta.append("?,");//codigo actividad
                                    consulta.append("?,");//orden actividad
                                    consulta.append("1,");
                                    consulta.append("?");//codigo actividad formula
                            consulta.append(")");
                PreparedStatement pstap=con.prepareStatement(consulta.toString());
                ResultSet res;
                for(ActividadesFormulaMaestra bean:actividadesFormulaMaestraAgregarList)
                {
                    if(bean.getChecked())
                    {
                        pst.setInt(1,bean.getActividadesProduccion().getCodActividad());LOGGER.info("p1:"+bean.getActividadesProduccion().getCodActividad());
                        pst.setInt(2,bean.getOrdenActividad());LOGGER.info("p2:"+bean.getOrdenActividad());
                        if(pst.executeUpdate()>0)LOGGER.info("se registro la actividad formula");
                        res=pst.getGeneratedKeys();
                        res.next();
                        pstap.setInt(1,bean.getActividadesProduccion().getCodActividad());
                        pstap.setInt(2,bean.getOrdenActividad());
                        pstap.setInt(3,res.getInt(1));
                        if(pstap.executeUpdate()>0)LOGGER.info("se registro la actividad produccion");
                    }
                }
                con.commit();
                mensaje = "1";
                pst.close();
            }
            catch (SQLException ex) 
            {
                mensaje = "Ocurrio un error al momento de guardar la transaccion";
                con.rollback();
                LOGGER.warn(ex.getMessage());
            }
            catch (Exception ex) 
            {
                mensaje = "Ocurrio un error al momento de guardar la transaccion,verifique los datos introducidos";
                LOGGER.warn(ex.getMessage());
            }
            finally 
            {
                this.cerrarConexion(con);
            }
            return null;
        }
    //</editor-fold>
    
   
    
    // <editor-fold defaultstate="collapsed" desc="funcion para agregar maqinarias general">
    public String agregarMaquinariaActividadGeneral_action()
    {
        this.cargarActividadesProduccionSelectList();
        this.cargarMaquinariasSelectList();
        this.cargarAreasEmpresaActividadSelectList();
        maquinariaActividadesFormulaAgregarGeneral=new MaquinariaActividadesFormula();
        maquinariaActividadesFormulaAgregarGeneral.getActividadesFormulaMaestra().getFormulaMaestra().getComponentesProd().setCodCompprod("0");
        maquinariaActividadesFormulaAgregarGeneral.getActividadesFormulaMaestra().getAreasEmpresa().setCodAreaEmpresa("0");
        return null;
    }
    public String guardarAgregarMaquinariaActividadGeneral_action()throws SQLException 
    {
        mensaje = "";
        try 
        {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta = new StringBuilder("INSERT INTO MAQUINARIA_ACTIVIDADES_FORMULA(COD_MAQUINA, COD_ACTIVIDAD_FORMULA, HORAS_MAQUINA2, HORAS_HOMBRE2, HORAS_HOMBRE,HORAS_MAQUINA, COD_ESTADO_REGISTRO)");
                                    consulta.append(" select ");
                                            consulta.append(maquinariaActividadesFormulaAgregarGeneral.getMaquinaria().getCodMaquina());
                                            consulta.append(" ,afm.COD_ACTIVIDAD_FORMULA");
                                            consulta.append(" ,").append(maquinariaActividadesFormulaAgregarGeneral.getHorasMaquina());
                                            consulta.append(" ,").append(maquinariaActividadesFormulaAgregarGeneral.getHorasHombre());
                                            consulta.append(" ,").append(maquinariaActividadesFormulaAgregarGeneral.getHorasHombre());
                                            consulta.append(" ,").append(maquinariaActividadesFormulaAgregarGeneral.getHorasMaquina());
                                            consulta.append(" ,1");
                                    consulta.append(" from ACTIVIDADES_FORMULA_MAESTRA afm");
                                    consulta.append(" inner join FORMULA_MAESTRA fm on afm.COD_FORMULA_MAESTRA=fm.COD_FORMULA_MAESTRA");
                                    consulta.append(" inner join COMPONENTES_PROD cp on fm.COD_ESTADO_REGISTRO=1 and fm.COD_COMPPROD=cp.COD_COMPPROD");
                                    consulta.append(" where afm.COD_ACTIVIDAD=").append(maquinariaActividadesFormulaAgregarGeneral.getActividadesFormulaMaestra().getActividadesProduccion().getCodActividad());
                                           consulta.append("  and afm.COD_AREA_EMPRESA=").append(maquinariaActividadesFormulaAgregarGeneral.getActividadesFormulaMaestra().getAreasEmpresa().getCodAreaEmpresa());
                                            if(!maquinariaActividadesFormulaAgregarGeneral.getActividadesFormulaMaestra().getFormulaMaestra().getComponentesProd().getAreasEmpresa().getCodAreaEmpresa().equals("0"))
                                                    consulta.append(" and cp.COD_AREA_EMPRESA=").append(maquinariaActividadesFormulaAgregarGeneral.getActividadesFormulaMaestra().getFormulaMaestra().getComponentesProd().getAreasEmpresa().getCodAreaEmpresa());
                                            if(!maquinariaActividadesFormulaAgregarGeneral.getActividadesFormulaMaestra().getAreasEmpresa().getCodAreaEmpresa().equals("0"))
                                                    consulta.append(" and afm.COD_AREA_EMPRESA=").append(maquinariaActividadesFormulaAgregarGeneral.getActividadesFormulaMaestra().getAreasEmpresa().getCodAreaEmpresa());
                                            consulta.append(" and afm.COD_ACTIVIDAD_FORMULA not in (");
                                                   consulta.append(" select maf.COD_ACTIVIDAD_FORMULA ");
                                                   consulta.append(" from MAQUINARIA_ACTIVIDADES_FORMULA maf");
                                                   consulta.append(" where maf.COD_MAQUINA=").append(maquinariaActividadesFormulaAgregarGeneral.getMaquinaria().getCodMaquina());
                                           consulta.append(")");
            LOGGER.debug("consulta agregar actividad general " + consulta.toString());
            PreparedStatement pst = con.prepareStatement(consulta.toString());
            if (pst.executeUpdate() > 0)LOGGER.info("Se registro la transacción");
            con.commit();
            mensaje = "1";
            pst.close();
        }
        catch (SQLException ex)
        {
            mensaje = "Ocurrio un error al momento de guardar la transaccion";
            con.rollback();
            LOGGER.warn(ex.getMessage());
        } 
        catch (Exception ex)
        {
            mensaje = "Ocurrio un error al momento de guardar la transaccion,verifique los datos introducidos";
            LOGGER.warn(ex.getMessage());
        }
        finally 
        {
            this.cerrarConexion(con);
        }
        return null;
    }
//</editor-fold>
    // <editor-fold defaultstate="collapsed" desc="funcion agregar actividad general">
    public String actividadInactivarActividadGeneral_action()
    {
        this.cargarActividadesProduccionSelectList();
        this.cargarAreasEmpresaActividadSelectList();
        actividadesFormulaMaestraGeneral=new ActividadesFormulaMaestra();
        actividadesFormulaMaestraGeneral.getFormulaMaestra().getComponentesProd().getAreasEmpresa().setCodAreaEmpresa("0");
        actividadesFormulaMaestraGeneral.getAreasEmpresa().setCodAreaEmpresa("0");
        return null;
    }
    public String activarActividadGeneral_action()throws SQLException
    {
        mensaje="";
        try
        {
            con=Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta=new StringBuilder("update ACTIVIDADES_FORMULA_MAESTRA");
                                    consulta.append(" set COD_ESTADO_REGISTRO=1 ");
                                    consulta.append(" where COD_ACTIVIDAD=").append(actividadesFormulaMaestraGeneral.getActividadesProduccion().getCodActividad());
                                    if(!actividadesFormulaMaestraGeneral.getFormulaMaestra().getComponentesProd().getAreasEmpresa().getCodAreaEmpresa().equals("0"))
                                    {
                                        consulta.append(" and COD_FORMULA_MAESTRA in (");
                                                consulta.append(" select fm.COD_FORMULA_MAESTRA");
                                                consulta.append(" from FORMULA_MAESTRA fm");
                                                consulta.append(" inner join COMPONENTES_PROD cp on fm.COD_COMPPROD=cp.COD_COMPPROD");
                                                        consulta.append(" and  cp.COD_AREA_EMPRESA=").append(actividadesFormulaMaestraGeneral.getFormulaMaestra().getComponentesProd().getAreasEmpresa().getCodAreaEmpresa());
                                                consulta.append(")");
                                    }
                                    if(!actividadesFormulaMaestraGeneral.getAreasEmpresa().getCodAreaEmpresa().equals("0"))
                                    {
                                        consulta.append(" and COD_AREA_EMPRESA=").append(actividadesFormulaMaestraGeneral.getAreasEmpresa().getCodAreaEmpresa());
                                    }
            System.out.println(" consulta update general "+consulta.toString());
            PreparedStatement pst = con.prepareStatement(consulta.toString(), PreparedStatement.RETURN_GENERATED_KEYS);
            if (pst.executeUpdate() > 0) LOGGER.info("Se registro la transacción");
            con.commit();
            mensaje = "1";
            pst.close();
        } catch (SQLException ex) {
            mensaje = "Ocurrio un error al momento de guardar la transaccion";
            con.rollback();
            LOGGER.warn(ex.getMessage());
        } catch (Exception ex) {
            mensaje = "Ocurrio un error al momento de guardar la transaccion,verifique los datos introducidos";
            LOGGER.warn(ex.getMessage());
        } finally {
            this.cerrarConexion(con);
        }
        return null;
    }
    public String inactivarActividadGeneral_action()throws SQLException
    {
        mensaje="";
        try
        {
            con=Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta=new StringBuilder("update ACTIVIDADES_FORMULA_MAESTRA");
                                    consulta.append(" set COD_ESTADO_REGISTRO=2 ");
                                    consulta.append(" where COD_ACTIVIDAD=").append(actividadesFormulaMaestraGeneral.getActividadesProduccion().getCodActividad());
                                    if(!actividadesFormulaMaestraGeneral.getFormulaMaestra().getComponentesProd().getAreasEmpresa().getCodAreaEmpresa().equals("0"))
                                    {
                                        consulta.append(" and COD_FORMULA_MAESTRA in (");
                                                consulta.append(" select fm.COD_FORMULA_MAESTRA");
                                                consulta.append(" from FORMULA_MAESTRA fm");
                                                consulta.append(" inner join COMPONENTES_PROD cp on fm.COD_COMPPROD=cp.COD_COMPPROD");
                                                        consulta.append(" and  cp.COD_AREA_EMPRESA=").append(actividadesFormulaMaestraGeneral.getFormulaMaestra().getComponentesProd().getAreasEmpresa().getCodAreaEmpresa());
                                                consulta.append(")");
                                    }
                                    if(!actividadesFormulaMaestraGeneral.getAreasEmpresa().getCodAreaEmpresa().equals("0"))
                                    {
                                        consulta.append(" and COD_AREA_EMPRESA=").append(actividadesFormulaMaestraGeneral.getAreasEmpresa().getCodAreaEmpresa());
                                    }
            System.out.println(" consulta update general "+consulta.toString());
            PreparedStatement pst = con.prepareStatement(consulta.toString(), PreparedStatement.RETURN_GENERATED_KEYS);
            if (pst.executeUpdate() > 0) LOGGER.info("Se registro la transacción");
            con.commit();
            mensaje = "1";
            pst.close();
        } catch (SQLException ex) {
            mensaje = "Ocurrio un error al momento de guardar la transaccion";
            con.rollback();
            LOGGER.warn(ex.getMessage());
        } catch (Exception ex) {
            mensaje = "Ocurrio un error al momento de guardar la transaccion,verifique los datos introducidos";
            LOGGER.warn(ex.getMessage());
        } finally {
            this.cerrarConexion(con);
        }
        return null;
    }
    //</editor-fold>
    
    // <editor-fold defaultstate="collapsed" desc="funcion para agergar actividad general">
    
    private void cargarActividadesAdicionarGeneral()
    {
        try
        {
            Connection con1=null;
            con1=Util.openConnection(con1);
            Statement st=con1.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select ap.COD_ACTIVIDAD,ap.NOMBRE_ACTIVIDAD from ACTIVIDADES_PRODUCCION ap where ap.COD_ESTADO_REGISTRO=1 order by ap.NOMBRE_ACTIVIDAD";
            ResultSet res=st.executeQuery(consulta);
            actividadesFMAdicionarGeneralList=new ArrayList<ActividadesFormulaMaestra>();
            while(res.next())
            {
                ActividadesFormulaMaestra nuevo=new ActividadesFormulaMaestra();
                nuevo.getActividadesProduccion().setCodActividad(res.getInt("COD_ACTIVIDAD"));
                nuevo.getActividadesProduccion().setNombreActividad(res.getString("NOMBRE_ACTIVIDAD"));
                actividadesFMAdicionarGeneralList.add(nuevo);
            }
            res.close();
            st.close();
            con1.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
    }
    
    
    public String agregarActividadFormulMaestraGeneral_action()
    {
        this.cargarAreasEmpresaActividadSelectList();
        this.cargarActividadesProduccionSelectList();
        this.cargarFormasFarmaceuticasSelect_action();
        this.cargarTiposProgramaProduccionSelectList();
        actividadesFMAdicionarGeneral=new ActividadesFormulaMaestra();
        codAreaEmpresa="0";
        return null;
    }
    public int nroOrdenActividad(String codAreaEmpresa,String codFormulaMaestra,String codPresentacion)
    {
        int nroActividad=0;
        try
        {
            Connection con1=null;
            con1=Util.openConnection(con1);
            Statement st=con1.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select ISNULL(max(afm.ORDEN_ACTIVIDAD),0)+1 as nroOrden" +
                            " from ACTIVIDADES_FORMULA_MAESTRA afm where afm.COD_AREA_EMPRESA='"+codAreaEmpresa+"'"+
                            " and afm.COD_FORMULA_MAESTRA='"+codFormulaMaestra+"' and afm.COD_PRESENTACION='"+codPresentacion+"'";
            System.out.println("consulta max"+consulta);
            ResultSet res=st.executeQuery(consulta);
            if(res.next())
            {
                nroActividad=res.getInt("nroOrden");
            }
            res.close();
            st.close();
            con1.close();
        }
       catch(SQLException ex)
       {
           ex.printStackTrace();
       }
        return nroActividad;
    }
    private void guardarActividadFormulaMaestra(int codActividad,String codFormula,String codPresentacion,
            String codArea)throws SQLException
    {
        Connection con2=null;
        int nro=this.nroOrdenActividad(codArea, codFormula,codPresentacion);
        try
        {
            con2=Util.openConnection(con2);
            String consulta="insert into actividades_formula_maestra(cod_actividad,cod_formula_maestra,orden_actividad,COD_AREA_EMPRESA,cod_estado_registro,COD_PRESENTACION)values("+
                            "'"+codActividad+"',"+
                            "'"+codFormula+"',"+
                            "'"+nro+"','"+codArea+"','1','"+codPresentacion+"')";
           System.out.println("con insert en actividades_formula "+consulta);
           PreparedStatement pst=con2.prepareStatement(consulta);
           if(pst.executeUpdate()>0)System.out.println("se registro para la actividad formula");
            consulta="insert into ACTIVIDADES_PROGRAMA_PRODUCCION(COD_ACTIVIDAD_PROGRAMA,cod_actividad,cod_formula_maestra,orden_actividad,COD_ESTADO_ACTIVIDAD)values("+
                                         "'"+codActividad+"',"+
                                         "'"+codFormula+"',"+
                                         "'"+nro+"',1)";
            System.out.println("insert ACTIVIDADES_PROGRAMA_PRODUCCION:"+consulta);
            pst=con2.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se registro para la actividad prog");
            pst.close();
            con2.close();
        }
        catch(SQLException ex)
        {
            System.out.println("registro duplicado");
        }
        finally
        {
            con2.close();
        }
    }
    public String guardarActividadFormulaMaestraGeneral_action()throws SQLException
    {
        transaccionExitosa=false;
        try 
        {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta = new StringBuilder("update ACTIVIDADES_FORMULA_MAESTRA set COD_ESTADO_REGISTRO=1")
                                                .append(" from ACTIVIDADES_FORMULA_MAESTRA afm ")
                                                        .append(" inner join FORMULA_MAESTRA fm on fm.COD_FORMULA_MAESTRA=afm.COD_FORMULA_MAESTRA")
                                                        .append(" inner join COMPONENTES_PROD cp ON cp.COD_COMPPROD=fm.COD_COMPPROD")
                                                .append(" where fm.COD_ESTADO_REGISTRO=1")
                                                        .append(" and afm.COD_ESTADO_REGISTRO<>1")
                                                        .append(" and afm.COD_AREA_EMPRESA=").append(codAreaEmpresa)
                                                        .append(" and afm.COD_ACTIVIDAD=").append(actividadesFMAdicionarGeneral.getActividadesProduccion().getCodActividad());
                                                        if(codAreaEmpresa.equals("96"))
                                                            consulta.append(" and afm.COD_TIPO_PROGRAMA_PROD=").append(actividadesFMAdicionarGeneral.getTiposProgramaProduccion().getCodTipoProgramaProd());
                                                        else
                                                            consulta.append(" and afm.COD_TIPO_PROGRAMA_PROD=0");
                                                        if(codAreaEmpresa.equals("84"))
                                                            consulta.append(" and afm.COD_PRESENTACION<>0");
                                                        else
                                                            consulta.append(" and afm.COD_PRESENTACION=0");
                                                        if( ! actividadesFMAdicionarGeneral.getFormulaMaestra().getComponentesProd().getForma().getCodForma().equals("0"))
                                                            consulta.append(" and cp.COD_FORMA=").append(actividadesFMAdicionarGeneral.getFormulaMaestra().getComponentesProd().getForma().getCodForma());
            LOGGER.debug("consulta activar actividades formula maestra inactivas "+consulta.toString());
            PreparedStatement pst = con.prepareStatement(consulta.toString());
            if (pst.executeUpdate() > 0) LOGGER.info("se ACTIVARON LAS ACTIVIDADES INACTIVAS");
            // <editor-fold defaultstate="collapsed" desc="determinando consulta de duplicacion">

            if(codAreaEmpresa.equals("84"))
            {
                consulta=new StringBuilder("INSERT INTO ACTIVIDADES_FORMULA_MAESTRA(COD_FORMULA_MAESTRA, COD_ACTIVIDAD,")
                                            .append("ORDEN_ACTIVIDAD, COD_AREA_EMPRESA, COD_ESTADO_REGISTRO, COD_PRESENTACION,")
                                            .append("COD_TIPO_PROGRAMA_PROD)")
                                .append(" select distinct fm.COD_FORMULA_MAESTRA,").append(actividadesFMAdicionarGeneral.getActividadesProduccion().getCodActividad()).append(",isnull(maximoActividad.orden,0)+1")
                                        .append(",").append(codAreaEmpresa)
                                        .append(",1,cpp.COD_PRESENTACION")
                                        .append(",0")
                                .append(" from FORMULA_MAESTRA fm ")
                                        .append(" inner join COMPONENTES_PROD cp ON cp.COD_COMPPROD = fm.COD_COMPPROD")
                                        .append(" inner join COMPONENTES_PRESPROD cpp on cpp.COD_COMPPROD=cp.COD_COMPPROD")
                                        .append(" left join(")
                                                .append(" select max(afm1.ORDEN_ACTIVIDAD) as orden,afm1.COD_FORMULA_MAESTRA,afm1.COD_PRESENTACION")
                                                .append(" from ACTIVIDADES_FORMULA_MAESTRA afm1")
                                                .append(" where afm1.COD_ESTADO_REGISTRO=1")
                                                        .append(" and afm1.COD_PRESENTACION<>0")
                                                        .append(" and afm1.COD_TIPO_PROGRAMA_PROD=0")
                                                        .append(" and afm1.COD_AREA_EMPRESA=").append(codAreaEmpresa)
                                                .append(" group by afm1.COD_FORMULA_MAESTRA,afm1.COD_PRESENTACION")
                                        .append(" ) as maximoActividad on maximoActividad.COD_FORMULA_MAESTRA=fm.COD_FORMULA_MAESTRA")
                                                .append(" and maximoActividad.COD_PRESENTACION=cpp.COD_PRESENTACION ")
                                        .append(" left outer join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_FORMULA_MAESTRA=fm.COD_FORMULA_MAESTRA")
                                        .append(" and afm.COD_PRESENTACION=cpp.COD_PRESENTACION")
                                        .append(" and afm.COD_TIPO_PROGRAMA_PROD=").append(codAreaEmpresa.equals("84")?actividadesFMAdicionarGeneral.getTiposProgramaProduccion().getCodTipoProgramaProd():0)
                                        .append(" and afm.COD_ACTIVIDAD=").append(actividadesFMAdicionarGeneral.getActividadesProduccion().getCodActividad())
                                        .append(" and afm.COD_AREA_EMPRESA=").append(codAreaEmpresa)
                                .append(" where fm.COD_ESTADO_REGISTRO = 1")
                                        .append(" and afm.COD_FORMULA_MAESTRA is null");
                                        if( ! actividadesFMAdicionarGeneral.getFormulaMaestra().getComponentesProd().getForma().getCodForma().equals("0"))
                                                            consulta.append(" and cp.COD_FORMA=").append(actividadesFMAdicionarGeneral.getFormulaMaestra().getComponentesProd().getForma().getCodForma());
            }
            else
            {
                consulta=new StringBuilder("INSERT INTO ACTIVIDADES_FORMULA_MAESTRA(COD_FORMULA_MAESTRA, COD_ACTIVIDAD,")
                                            .append("ORDEN_ACTIVIDAD, COD_AREA_EMPRESA, COD_ESTADO_REGISTRO, COD_PRESENTACION,")
                                            .append("COD_TIPO_PROGRAMA_PROD)")
                                .append(" select fm.COD_FORMULA_MAESTRA,").append(actividadesFMAdicionarGeneral.getActividadesProduccion().getCodActividad()).append(",isnull(maximoActividad.orden,0)+1")
                                        .append(",").append(codAreaEmpresa).append(",1,0,")
                                        .append(codAreaEmpresa.equals("96")?actividadesFMAdicionarGeneral.getTiposProgramaProduccion().getCodTipoProgramaProd():0)
                                .append(" from FORMULA_MAESTRA fm ")
                                        .append(" inner join COMPONENTES_PROD cp ON cp.COD_COMPPROD = fm.COD_COMPPROD")
                                        .append(" left join(")
                                                .append(" select max(afm1.ORDEN_ACTIVIDAD) as orden,afm1.COD_FORMULA_MAESTRA")
                                                .append(" from ACTIVIDADES_FORMULA_MAESTRA afm1")
                                                .append(" where afm1.COD_ESTADO_REGISTRO=1")
                                                        .append(" and afm1.COD_PRESENTACION=0")
                                                        .append(" and afm1.COD_TIPO_PROGRAMA_PROD=").append(codAreaEmpresa.equals("96")?actividadesFMAdicionarGeneral.getTiposProgramaProduccion().getCodTipoProgramaProd():0)
                                                        .append(" and afm1.COD_AREA_EMPRESA=").append(codAreaEmpresa)
                                                .append(" group by afm1.COD_FORMULA_MAESTRA")
                                        .append(" ) as maximoActividad on maximoActividad.COD_FORMULA_MAESTRA=fm.COD_FORMULA_MAESTRA")
                                        .append(" left outer join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_FORMULA_MAESTRA=fm.COD_FORMULA_MAESTRA")
                                        .append(" and afm.COD_PRESENTACION=0")
                                        .append(" and afm.COD_TIPO_PROGRAMA_PROD=").append(codAreaEmpresa.equals("96")?actividadesFMAdicionarGeneral.getTiposProgramaProduccion().getCodTipoProgramaProd():0)
                                        .append(" and afm.COD_ACTIVIDAD=").append(actividadesFMAdicionarGeneral.getActividadesProduccion().getCodActividad())
                                        .append(" and afm.COD_AREA_EMPRESA=").append(codAreaEmpresa)
                                .append(" where fm.COD_ESTADO_REGISTRO = 1")
                                        .append(" and afm.COD_FORMULA_MAESTRA is null");
                                        if( ! actividadesFMAdicionarGeneral.getFormulaMaestra().getComponentesProd().getForma().getCodForma().equals("0"))
                                                consulta.append(" and cp.COD_FORMA=").append(actividadesFMAdicionarGeneral.getFormulaMaestra().getComponentesProd().getForma().getCodForma());
            }
            this.mostrarMensajeTransaccionExitosa("Se registro satisfactoriamente la actividad");
            //</editor-fold>
            LOGGER.debug("consulta registrar actividad formula "+consulta.toString());
            pst=con.prepareStatement(consulta.toString());
            if(pst.executeUpdate()>0)LOGGER.info("se registro la actividad formula");
            con.commit();
            mensaje = "1";
        } catch (SQLException ex) {
            this.mostrarMensajeTransaccionFallida("Ocurrio un error de datos al momento de guardar la desviacion, verifique la información e intente de nuevo");
            LOGGER.warn(ex.getMessage());
            con.rollback();
        } catch (NumberFormatException ex) {
            this.mostrarMensajeTransaccionFallida("Ocurrio un error de datos al momento de guardar la desviacion, verifique la información e intente de nuevo");
            LOGGER.warn(ex.getMessage());
            con.rollback();
        } finally {
            con.close();
        }
        
        return null;
    }
    //</editor-fold>
    
    // <editor-fold defaultstate="collapsed" desc="funcion para duplica actividades"/>
    public String codAreaEmpresaActividad_change()
    {
        actividadesFormulaMaestraDuplicarList=new ArrayList<ActividadesFormulaMaestra>();
        actividadesFormulaMaestraDuplicar.getPresentacionesProducto().setCodPresentacion("0");
        actividadesFormulaMaestraDuplicar.getTiposProgramaProduccion().setCodTipoProgramaProd("0");
        return null;
    }
    public String vaciarActividadFormulaMaestraDuplicarList_action()
    {
        actividadesFormulaMaestraDuplicarList=new ArrayList<ActividadesFormulaMaestra>();
        return null;
    }
    public String codFormulaMaestra_change()
    {
        actividadesFormulaMaestraDuplicarList=new ArrayList<ActividadesFormulaMaestra>();
        actividadesFormulaMaestraDuplicar.getPresentacionesProducto().setCodPresentacion("0");
        try 
        {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select distinct pp.cod_presentacion,pp.NOMBRE_PRODUCTO_PRESENTACION");
                                    consulta.append(" from FORMULA_MAESTRA fm");
                                            consulta.append(" inner join COMPONENTES_PRESPROD cpp on fm.COD_COMPPROD=cpp.COD_COMPPROD");
                                                    consulta.append(" and cpp.COD_ESTADO_REGISTRO=1");
                                            consulta.append(" inner join PRESENTACIONES_PRODUCTO pp on pp.cod_presentacion=cpp.COD_PRESENTACION");
                                                    consulta.append(" and pp.cod_estado_registro in (");
                                                            consulta.append(" select e.COD_ESTADO_PRESENTACION_PRODUCTO ");
                                                            consulta.append(" from ESTADOS_PRESENTACIONES_PRODUCTO e");
                                                            consulta.append(" where e.TRANSACCIONABLE_PRODUCCION = 1 ");
                                                    consulta.append(")");
                                    consulta.append(" WHERE fm.COD_FORMULA_MAESTRA=").append(actividadesFormulaMaestraDuplicar.getFormulaMaestra().getCodFormulaMaestra());
                                    consulta.append(" order by pp.NOMBRE_PRODUCTO_PRESENTACION");
            LOGGER.debug("consulta cargar presentciones "+consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            presentacionesSelectList=new ArrayList<SelectItem>();
            while(res.next())
            {
                presentacionesSelectList.add(new SelectItem(res.getInt("cod_presentacion"),res.getString("NOMBRE_PRODUCTO_PRESENTACION")));

            }
            st.close();
        } catch (SQLException ex) {
            LOGGER.warn("error", ex);
        } finally {
            this.cerrarConexion(con);
        }
        
        return null;
    }
    
    
    public String codFormulaMaestraDestino_change()
    {
        actividadesFormulaMaestraDestino.getPresentacionesProducto().setCodPresentacion("0");
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select distinct pp.cod_presentacion,pp.NOMBRE_PRODUCTO_PRESENTACION");
                                    consulta.append(" from FORMULA_MAESTRA fm");
                                            consulta.append(" inner join COMPONENTES_PRESPROD cpp on fm.COD_COMPPROD=cpp.COD_COMPPROD");
                                                    consulta.append(" and cpp.COD_ESTADO_REGISTRO=1");
                                            consulta.append(" inner join PRESENTACIONES_PRODUCTO pp on pp.cod_presentacion=cpp.COD_PRESENTACION");
                                                    consulta.append(" and pp.cod_estado_registro in (");
                                                    consulta.append(" select e.COD_ESTADO_PRESENTACION_PRODUCTO ");
                                                    consulta.append(" from ESTADOS_PRESENTACIONES_PRODUCTO e");
                                                    consulta.append(" where e.TRANSACCIONABLE_PRODUCCION = 1 )");
                                    consulta.append(" WHERE fm.COD_FORMULA_MAESTRA=").append(actividadesFormulaMaestraDestino.getFormulaMaestra().getCodFormulaMaestra());
                                    consulta.append(" order by pp.NOMBRE_PRODUCTO_PRESENTACION");
            LOGGER.debug("consulta cargar presentacion destino "+consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            presentacionesDestinoSelectList=new ArrayList<SelectItem>();
             while(res.next())
             {
                 presentacionesDestinoSelectList.add(new SelectItem(res.getInt("cod_presentacion"),res.getString("NOMBRE_PRODUCTO_PRESENTACION")));
             }
            st.close();
        } catch (SQLException ex) {
            LOGGER.warn("error", ex);
        } finally {
            this.cerrarConexion(con);
        }
        
        return null;
    }
    
    public String replicarDatosActividadesFormula()throws SQLException
    {
        transaccionExitosa=false;
        int cantidadActividadesYaRegistradas=0;
        try {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta = new StringBuilder("INSERT INTO ACTIVIDADES_FORMULA_MAESTRA(COD_FORMULA_MAESTRA, COD_ACTIVIDAD, ORDEN_ACTIVIDAD, COD_AREA_EMPRESA,COD_ESTADO_REGISTRO, COD_PRESENTACION,COD_TIPO_PROGRAMA_PROD)");
                                    consulta.append(" VALUES (");
                                            consulta.append(actividadesFormulaMaestraDestino.getFormulaMaestra().getCodFormulaMaestra()).append(",");
                                            consulta.append("?,");//codigo actividad
                                            consulta.append("?,");//orden
                                            consulta.append(actividadesFormulaMaestraDuplicar.getAreasEmpresa().getCodAreaEmpresa()).append(",");
                                            consulta.append("1,");
                                            consulta.append(actividadesFormulaMaestraDestino.getPresentacionesProducto().getCodPresentacion()).append(",");
                                            consulta.append(actividadesFormulaMaestraDuplicar.getTiposProgramaProduccion().getCodTipoProgramaProd());
                                    consulta.append(")");
            LOGGER.debug("consulta pst registrar "+consulta.toString());
            PreparedStatement pst=con.prepareStatement(consulta.toString(),PreparedStatement.RETURN_GENERATED_KEYS);
            for(ActividadesFormulaMaestra bean:actividadesFormulaMaestraDuplicarList){
                
                if(bean.getChecked())
                {
                    try
                    {
                        pst.setInt(1,bean.getActividadesProduccion().getCodActividad());LOGGER.info("p1 :"+bean.getActividadesProduccion().getCodActividad());
                        pst.setInt(2,bean.getOrdenActividad());LOGGER.info("p2 :"+bean.getOrdenActividad());
                        if(pst.executeUpdate()>0)LOGGER.info("se registro la actividad");
                    }
                    catch(SQLException ex)
                    {
                        cantidadActividadesYaRegistradas++;
                        LOGGER.info("la actividad ya esta registrada");
                    }
                }
               
                
            }
            con.commit();
            mensaje = "1";
            pst.close();
            this.mostrarMensajeTransaccionExitosa("Se registro Satisfactoriamente la duplicacion de actividades"
                                                    +(cantidadActividadesYaRegistradas>0?",no obstante existen "+cantidadActividadesYaRegistradas+" que no se duplicaron":""));
        } 
        catch (SQLException ex) {
            this.mostrarMensajeTransaccionFallida("Ocurrio un error al momento de duplicar las actividades");
            con.rollback();
            LOGGER.warn(ex.getMessage());
        } catch (Exception ex) {
            this.mostrarMensajeTransaccionFallida("Ocurrio un error al momento de duplicar las actividades");
            LOGGER.warn(ex.getMessage());
        } finally {
            this.cerrarConexion(con);
        }
        
        return null;
    }
    
    
    public String getCargarDuplicarActividades()
    {
        actividadesFormulaMaestraDuplicar=new ActividadesFormulaMaestra();
        actividadesFormulaMaestraDestino=new ActividadesFormulaMaestra();
        this.cargarTiposProgramaProduccionSelectList();
        this.cargarAreasEmpresaActividadSelectList();
        this.cargarComponentesProdSelect();
        actividadesFormulaMaestraDuplicar.getAreasEmpresa().setCodAreaEmpresa("0");
        actividadesFormulaMaestraDuplicar.getFormulaMaestra().setCodFormulaMaestra((String)formulaMaestraSelectList.get(0).getValue());
        actividadesFormulaMaestraDestino.getFormulaMaestra().setCodFormulaMaestra((String)formulaMaestraSelectList.get(0).getValue());
        actividadesFormulaMaestraDuplicarList.clear();
        codFormulaMaestra_change();
        codFormulaMaestraDestino_change();
        return null;
    }
    public String buscarActidadesDatosFiltro_action()
    {
        this.cargarActividadesFormulaMaestraHorasDuplicar();
        return null;
    }
    private Double redondeoDosDecimales(Double numero)
    {
        return Math.rint(numero*100)/100;
    }
    private void cargarActividadesFormulaMaestraHorasDuplicar()
    {
        DaoActividadesFormulaMaestra daoActividadesFormulaMaestra=new DaoActividadesFormulaMaestra();
        actividadesFormulaMaestraDuplicarList=daoActividadesFormulaMaestra.listar(actividadesFormulaMaestraDuplicar);
        
    }
//</editor-fold>
    
    
    
// <editor-fold defaultstate="collapsed" desc="getter and seter">

    public FormulaMaestra getFormulaMaestraSeleccionada() {
        return formulaMaestraSeleccionada;
    }

    public void setFormulaMaestraSeleccionada(FormulaMaestra formulaMaestraSeleccionada) {
        this.formulaMaestraSeleccionada = formulaMaestraSeleccionada;
    }
    
    
    
    


    public String getMensaje() {
        return mensaje;
    }

    public void setMensaje(String mensaje) {
        this.mensaje = mensaje;
    }

    public List<FormulaMaestra> getFormulaMaestraList() {
        return formulaMaestraList;
    }

    public void setFormulaMaestraList(List<FormulaMaestra> formulaMaestraList) {
        this.formulaMaestraList = formulaMaestraList;
    }

    public FormulaMaestra getFormulaMaestraBuscar() {
        return formulaMaestraBuscar;
    }

    public void setFormulaMaestraBuscar(FormulaMaestra formulaMaestraBuscar) {
        this.formulaMaestraBuscar = formulaMaestraBuscar;
    }

    public FormulaMaestra getFormulaMaestraBean() {
        return formulaMaestraSeleccionada;
    }

    public void setFormulaMaestraBean(FormulaMaestra formulaMaestraSeleccionada) {
        this.formulaMaestraSeleccionada = formulaMaestraSeleccionada;
    }

    public List<SelectItem> getTiposProduccionSelectList() {
        return tiposProduccionSelectList;
    }

    public void setTiposProduccionSelectList(List<SelectItem> tiposProduccionSelectList) {
        this.tiposProduccionSelectList = tiposProduccionSelectList;
    }

    public List<SelectItem> getEstadosCompProdSelectList() {
        return estadosCompProdSelectList;
    }

    public void setEstadosCompProdSelectList(List<SelectItem> estadosCompProdSelectList) {
        this.estadosCompProdSelectList = estadosCompProdSelectList;
    }

    public List<SelectItem> getAreasEmpresaSelectList() {
        return areasEmpresaSelectList;
    }

    public void setAreasEmpresaSelectList(List<SelectItem> areasEmpresaSelectList) {
        this.areasEmpresaSelectList = areasEmpresaSelectList;
    }

    public List<SelectItem> getMaquinariasSelectList() {
        return maquinariasSelectList;
    }

    public void setMaquinariasSelectList(List<SelectItem> maquinariasSelectList) {
        this.maquinariasSelectList = maquinariasSelectList;
    }

    public List<SelectItem> getActividadesProduccionSelectList() {
        return actividadesProduccionSelectList;
    }

    public void setActividadesProduccionSelectList(List<SelectItem> actividadesProduccionSelectList) {
        this.actividadesProduccionSelectList = actividadesProduccionSelectList;
    }

    

    public List<SelectItem> getAreasEmpresaActividadSelectList() {
        return areasEmpresaActividadSelectList;
    }

    public void setAreasEmpresaActividadSelectList(List<SelectItem> areasEmpresaActividadSelectList) {
        this.areasEmpresaActividadSelectList = areasEmpresaActividadSelectList;
    }

    public List<SelectItem> getPresentacionesProductoSelectList() {
        return presentacionesProductoSelectList;
    }

    public void setPresentacionesProductoSelectList(List<SelectItem> presentacionesProductoSelectList) {
        this.presentacionesProductoSelectList = presentacionesProductoSelectList;
    }

    public List<ActividadFormulaMaestraBloque> getActividadFormulaMaestraBloqueList() {
        return actividadFormulaMaestraBloqueList;
    }

    public void setActividadFormulaMaestraBloqueList(List<ActividadFormulaMaestraBloque> actividadFormulaMaestraBloqueList) {
        this.actividadFormulaMaestraBloqueList = actividadFormulaMaestraBloqueList;
    }

    

    public ActividadesFormulaMaestra getActividadesFormulaMaestraBuscar() {
        return actividadesFormulaMaestraBuscar;
    }

    public void setActividadesFormulaMaestraBuscar(ActividadesFormulaMaestra actividadesFormulaMaestraBuscar) {
        this.actividadesFormulaMaestraBuscar = actividadesFormulaMaestraBuscar;
    }

    public List<ActividadesFormulaMaestra> getActividadesFormulaMaestraAgregarList() {
        return actividadesFormulaMaestraAgregarList;
    }

    public void setActividadesFormulaMaestraAgregarList(List<ActividadesFormulaMaestra> actividadesFormulaMaestraAgregarList) {
        this.actividadesFormulaMaestraAgregarList = actividadesFormulaMaestraAgregarList;
    }

    public ActividadesFormulaMaestra getActividadesFormulaMaestraEditar() {
        return actividadesFormulaMaestraEditar;
    }

    public void setActividadesFormulaMaestraEditar(ActividadesFormulaMaestra actividadesFormulaMaestraEditar) {
        this.actividadesFormulaMaestraEditar = actividadesFormulaMaestraEditar;
    }

    public MaquinariaActividadesFormula getMaquinariaActividadesFormulaAgregarGeneral() {
        return maquinariaActividadesFormulaAgregarGeneral;
    }

    public void setMaquinariaActividadesFormulaAgregarGeneral(MaquinariaActividadesFormula maquinariaActividadesFormulaAgregarGeneral) {
        this.maquinariaActividadesFormulaAgregarGeneral = maquinariaActividadesFormulaAgregarGeneral;
    }

    public ActividadesFormulaMaestra getActividadesFormulaMaestraGeneral() {
        return actividadesFormulaMaestraGeneral;
    }

    public void setActividadesFormulaMaestraGeneral(ActividadesFormulaMaestra actividadesFormulaMaestraGeneral) {
        this.actividadesFormulaMaestraGeneral = actividadesFormulaMaestraGeneral;
    }

    public List<ActividadesFormulaMaestra> getActividadesFMAdicionarGeneralList() {
        return actividadesFMAdicionarGeneralList;
    }

    public void setActividadesFMAdicionarGeneralList(List<ActividadesFormulaMaestra> actividadesFMAdicionarGeneralList) {
        this.actividadesFMAdicionarGeneralList = actividadesFMAdicionarGeneralList;
    }

    public List<SelectItem> getFormasFarmaceuticasSelectList() {
        return formasFarmaceuticasSelectList;
    }

    public void setFormasFarmaceuticasSelectList(List<SelectItem> formasFarmaceuticasSelectList) {
        this.formasFarmaceuticasSelectList = formasFarmaceuticasSelectList;
    }

    public ActividadesFormulaMaestra getActividadesFMAdicionarGeneral() {
        return actividadesFMAdicionarGeneral;
    }

    public void setActividadesFMAdicionarGeneral(ActividadesFormulaMaestra actividadesFMAdicionarGeneral) {
        this.actividadesFMAdicionarGeneral = actividadesFMAdicionarGeneral;
    }

    public List<SelectItem> getTiposProgramaProduccionSelectList() {
        return tiposProgramaProduccionSelectList;
    }

    public void setTiposProgramaProduccionSelectList(List<SelectItem> tiposProgramaProduccionSelectList) {
        this.tiposProgramaProduccionSelectList = tiposProgramaProduccionSelectList;
    }
    

    public List<ActividadesFormulaMaestra> getActividadesFormulaMaestraDuplicarList() {
        return actividadesFormulaMaestraDuplicarList;
    }

    public void setActividadesFormulaMaestraDuplicarList(List<ActividadesFormulaMaestra> actividadesFormulaMaestraDuplicarList) {
        this.actividadesFormulaMaestraDuplicarList = actividadesFormulaMaestraDuplicarList;
    }

    public ActividadesFormulaMaestra getActividadesFormulaMaestraDuplicar() {
        return actividadesFormulaMaestraDuplicar;
    }

    public void setActividadesFormulaMaestraDuplicar(ActividadesFormulaMaestra actividadesFormulaMaestraDuplicar) {
        this.actividadesFormulaMaestraDuplicar = actividadesFormulaMaestraDuplicar;
    }

    public ActividadesFormulaMaestra getActividadesFormulaMaestraDestino() {
        return actividadesFormulaMaestraDestino;
    }

    public void setActividadesFormulaMaestraDestino(ActividadesFormulaMaestra actividadesFormulaMaestraDestino) {
        this.actividadesFormulaMaestraDestino = actividadesFormulaMaestraDestino;
    }


    public List<SelectItem> getActividadesProduccionGestionarSelectList() {
        return actividadesProduccionGestionarSelectList;
    }

    public void setActividadesProduccionGestionarSelectList(List<SelectItem> actividadesProduccionGestionarSelectList) {
        this.actividadesProduccionGestionarSelectList = actividadesProduccionGestionarSelectList;
    }

    public ActividadesFormulaMaestra getActividadesFormulaMaestraGestionar() {
        return actividadesFormulaMaestraGestionar;
    }

    public void setActividadesFormulaMaestraGestionar(ActividadesFormulaMaestra actividadesFormulaMaestraGestionar) {
        this.actividadesFormulaMaestraGestionar = actividadesFormulaMaestraGestionar;
    }
    
    


    public ActividadFormulaMaestraBloque getActividadFormulaMaestraBloqueGestionar() {
        return actividadFormulaMaestraBloqueGestionar;
    }

    public void setActividadFormulaMaestraBloqueGestionar(ActividadFormulaMaestraBloque actividadFormulaMaestraBloqueGestionar) {
        this.actividadFormulaMaestraBloqueGestionar = actividadFormulaMaestraBloqueGestionar;
    }


    public String getCodAreaEmpresa() {
        return codAreaEmpresa;
    }

    public void setCodAreaEmpresa(String codAreaEmpresa) {
        this.codAreaEmpresa = codAreaEmpresa;
    }

    public List<SelectItem> getPresentacionesSelectList() {
        return presentacionesSelectList;
    }

    public void setPresentacionesSelectList(List<SelectItem> presentacionesSelectList) {
        this.presentacionesSelectList = presentacionesSelectList;
    }

    public List<SelectItem> getPresentacionesDestinoSelectList() {
        return presentacionesDestinoSelectList;
    }

    public void setPresentacionesDestinoSelectList(List<SelectItem> presentacionesDestinoSelectList) {
        this.presentacionesDestinoSelectList = presentacionesDestinoSelectList;
    }

    public List<SelectItem> getFormulaMaestraSelectList() {
        return formulaMaestraSelectList;
    }

    public void setFormulaMaestraSelectList(List<SelectItem> formulaMaestraSelectList) {
        this.formulaMaestraSelectList = formulaMaestraSelectList;
    }

    public boolean isEliminarDatosActividadesDestino() {
        return eliminarDatosActividadesDestino;
    }

    public void setEliminarDatosActividadesDestino(boolean eliminarDatosActividadesDestino) {
        this.eliminarDatosActividadesDestino = eliminarDatosActividadesDestino;
    }

    public boolean isProductosConPresentaciones() {
        return productosConPresentaciones;
    }

    public void setProductosConPresentaciones(boolean productosConPresentaciones) {
        this.productosConPresentaciones = productosConPresentaciones;
    }
    
    //</editor-fold>
    
}
