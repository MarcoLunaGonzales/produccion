
/*
 * ManagedTipoCliente.java
 * Created on 19 de febrero de 2008, 16:50
 */
package com.cofar.web;

import com.cofar.bean.Maquinaria;
import com.cofar.bean.Materiales;
import com.cofar.bean.PartesMaquinaria;
import com.cofar.dao.DaoMateriales;
import com.cofar.util.Util;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import javax.faces.model.SelectItem;
import java.text.SimpleDateFormat;
import org.apache.logging.log4j.LogManager;
import org.richfaces.component.html.HtmlDataTable;

/**
 *
 *  @author Wilmer Manzaneda Chavez
 *  @company COFAR
 */
public class ManagedMaquinaria extends ManagedBean{

    //<editor-fold desc="variables managed maquinaria">
        private Connection con=null;
        private String mensaje="";
        private List<Maquinaria> maquinariasList;
        private List<SelectItem> areasEmpresaSelectList;
        private List<SelectItem> tiposEquipoSelectList;
        private List<SelectItem> marcasMaquinariaSelectList;
        private List<SelectItem> materialesSelectList;
        private Maquinaria maquinariaBuscar;
        private Maquinaria maquinariaAgregar;
        private Maquinaria maquinariaEditar;
        private HtmlDataTable maquinariaDataTable=new HtmlDataTable();
        //variables para partes de maquinaria
        private List<PartesMaquinaria> partesMaquinariaList;
        private PartesMaquinaria partesMaquinariaAgregar;
        private PartesMaquinaria partesMaquinariaEditar;
        private Maquinaria maquinariaBean;
    //</editor-fold>

    //<editor-fold desc="partes de maquinaria" defaultstate="collapsed">
        public String guardarEdicionParteMaquinaria_action()throws SQLException
        {
            mensaje = "";
            try
            {
                con = Util.openConnection(con);
                con.setAutoCommit(false);
                ManagedAccesoSistema managed=(ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
                        StringBuilder consulta = new StringBuilder("exec PAA_REGISTRO_PARTES_MAQUINARIA_LOG ");
                                                consulta.append(partesMaquinariaEditar.getCodParteMaquina()).append(",");
                                                consulta.append(managed.getUsuarioModuloBean().getCodUsuarioGlobal()).append(",");
                                                consulta.append("1");//tipo transaccion update
                LOGGER.debug("consulta registrar edicion log parte maquinaria "+consulta.toString());
                PreparedStatement pst = con.prepareStatement(consulta.toString());
                if(pst.executeUpdate()>0)LOGGER.info("se registro el log de edicion de la parte maquinaria");
                consulta = new StringBuilder("UPDATE PARTES_MAQUINARIA  ");
                            consulta.append(" SET CODIGO =?");
                            consulta.append(" ,COD_TIPO_EQUIPO = ").append(partesMaquinariaEditar.getTiposEquiposMaquinaria().getCodTipoEquipo());
                            consulta.append(" , NOMBRE_PARTE_MAQUINA = ?");
                            consulta.append(" ,OBS_PARTE_MAQUINA = ?");
                            consulta.append(" ,COD_MATERIAL=").append(partesMaquinariaEditar.getMateriales().getCodMaterial());
                            consulta.append(" WHERE ");
                            consulta.append(" COD_PARTE_MAQUINA = ").append(partesMaquinariaEditar.getCodParteMaquina());
                LOGGER.debug("consulta editar parte maquinaria" + consulta.toString());
                pst=con.prepareStatement(consulta.toString());
                pst.setString(1,partesMaquinariaEditar.getCodigo());LOGGER.info("p1:"+partesMaquinariaEditar.getCodigo());
                pst.setString(2,partesMaquinariaEditar.getNombreParteMaquina());LOGGER.info("p2:"+partesMaquinariaEditar.getNombreParteMaquina());
                pst.setString(3,partesMaquinariaEditar.getObsParteMaquina());LOGGER.info("p3:"+partesMaquinariaEditar.getNombreParteMaquina());
                if (pst.executeUpdate() > 0) LOGGER.info("se registro la edicion de la parte maquinaria");
                con.commit();
                mensaje = "1";
            } catch (SQLException ex) {
                mensaje = "Ocurrio un error al momento de guardar el registro";
                LOGGER.warn(ex.getMessage());
                con.rollback();
            } catch (Exception ex) {
                mensaje = "Ocurrio un error al momento de guardar el registro,verifique los datos introducidos";
                LOGGER.warn(ex.getMessage());
            } finally {
                this.cerrarConexion(con);
            }
            return null;
        }

        public String getCargarAgregarPartesMaquinaria_action()
        {
            partesMaquinariaAgregar=new PartesMaquinaria();
            this.cargarTiposEquipoSelectList();
            return null;
        }
        public String guardarAgregarPartesMaquinaria_action()throws SQLException
        {
            mensaje = "";
            try {
                con = Util.openConnection(con);
                con.setAutoCommit(false);
                StringBuilder consulta = new StringBuilder("INSERT INTO PARTES_MAQUINARIA(COD_MAQUINA, CODIGO,COD_TIPO_EQUIPO, NOMBRE_PARTE_MAQUINA, OBS_PARTE_MAQUINA,COD_MATERIAL)");
                                        consulta.append(" VALUES (");
                                                    consulta.append(maquinariaBean.getCodMaquina()).append(",");
                                                    consulta.append("?,");//codigo
                                                    consulta.append(partesMaquinariaAgregar.getTiposEquiposMaquinaria().getCodTipoEquipo()).append(",");
                                                    consulta.append("?,");//nombre tipo maquinaria
                                                    consulta.append("?,");//observacion tipo maquinaria
                                                    consulta.append(partesMaquinariaAgregar.getMateriales().getCodMaterial());
                                        consulta.append(")");
                LOGGER.debug("consulta registrar parte maquinaria " + consulta.toString());
                PreparedStatement pst = con.prepareStatement(consulta.toString(), PreparedStatement.RETURN_GENERATED_KEYS);
                pst.setString(1,partesMaquinariaAgregar.getCodigo());LOGGER.info("p1:"+partesMaquinariaAgregar.getCodigo());
                pst.setString(2,partesMaquinariaAgregar.getNombreParteMaquina());LOGGER.info("p2:"+partesMaquinariaAgregar.getNombreParteMaquina());
                pst.setString(3,partesMaquinariaAgregar.getObsParteMaquina());LOGGER.info("p3:"+partesMaquinariaAgregar.getObsParteMaquina());
                if (pst.executeUpdate() > 0) LOGGER.info("se registro la parte maquinaria");
                ResultSet res=pst.getGeneratedKeys();
                if(res.next())partesMaquinariaAgregar.setCodParteMaquina(res.getInt(1));
                ManagedAccesoSistema managed=(ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
                consulta = new StringBuilder("exec PAA_REGISTRO_PARTES_MAQUINARIA_LOG ");
                            consulta.append(partesMaquinariaAgregar.getCodParteMaquina()).append(",");
                            consulta.append(managed.getUsuarioModuloBean().getCodUsuarioGlobal()).append(",");
                            consulta.append("3");//tipo transaccion agregar
                LOGGER.debug("consulta registrar log agregar "+consulta.toString());
                pst=con.prepareStatement(consulta.toString());
                if(pst.executeUpdate()>0)LOGGER.info("se registro la parte maquinaria agregar");
                con.commit();
                mensaje = "1";
            } catch (SQLException ex) {
                mensaje = "Ocurrio un error al momento de guardar el registro";
                LOGGER.warn(ex.getMessage());
                con.rollback();
            } catch (Exception ex) {
                mensaje = "Ocurrio un error al momento de guardar el registro,verifique los datos introducidos";
                LOGGER.warn(ex.getMessage());
            } finally {
                this.cerrarConexion(con);
            }
            return null;
        }
        public String editarPartesMaquinaria_action()
        {
            for(PartesMaquinaria bean:partesMaquinariaList)
            {
                if(bean.getChecked())
                {
                    partesMaquinariaEditar=bean;

                    break;
                }
            }
            return null;
        }
        public String eliminarPartesMaquinaria_action()throws SQLException
        {
            for(PartesMaquinaria bean:partesMaquinariaList)
            {
                if(bean.getChecked())
                {
                    mensaje = "";
                    try
                    {
                        con = Util.openConnection(con);
                        con.setAutoCommit(false);
                        ManagedAccesoSistema managed=(ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
                        StringBuilder consulta = new StringBuilder("exec PAA_REGISTRO_PARTES_MAQUINARIA_LOG ");
                                                consulta.append(bean.getCodParteMaquina()).append(",");
                                                consulta.append(managed.getUsuarioModuloBean().getCodUsuarioGlobal()).append(",");
                                                consulta.append("2");//tipo transaccion eliminacion
                        LOGGER.debug("consulta registrar log " + consulta.toString());
                        PreparedStatement pst = con.prepareStatement(consulta.toString());
                        if (pst.executeUpdate() > 0) LOGGER.info("se el log de parte maquinaria");
                        consulta=new StringBuilder(" DELETE PARTES_MAQUINARIA");
                                   consulta.append(" where COD_PARTE_MAQUINA=").append(bean.getCodParteMaquina());
                        LOGGER.debug("consulta delete parte maquinaria "+consulta.toString());
                        pst=con.prepareStatement(consulta.toString());
                        if(pst.executeUpdate()>0)LOGGER.info("se elimino la parte de la maquinaria");
                        con.commit();
                        mensaje = "1";
                    }
                    catch (SQLException ex)
                    {
                        mensaje = "Ocurrio un error al momento de guardar el registro";
                        LOGGER.warn(ex.getMessage());
                        con.rollback();
                    }
                    catch (Exception ex)
                    {
                        mensaje = "Ocurrio un error al momento de guardar el registro,verifique los datos introducidos";
                        LOGGER.warn(ex.getMessage());
                    } finally {
                        this.cerrarConexion(con);
                    }
                    break;
                }
            }
            return null;
        }
        public String seleccionarMaquinaria_action()
        {
            maquinariaBean=(Maquinaria)maquinariaDataTable.getRowData();
            return null;
        }
        public String getCargarPartesMaquinariaList()
        {
            this.cargarTiposEquipoSelectList();
            this.cargarPartesMaquinariaList();
            return null;
        }
        private void cargarPartesMaquinariaList()
        {
            try
            {
                con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("select pm.COD_PARTE_MAQUINA,pm.COD_TIPO_EQUIPO,tem.NOMBRE_TIPO_EQUIPO,");
                                                    consulta.append(" pm.CODIGO,pm.NOMBRE_PARTE_MAQUINA,pm.OBS_PARTE_MAQUINA");
                                                    consulta.append(" ,pm.COD_MATERIAL,m.NOMBRE_MATERIAL");
                                            consulta.append(" from PARTES_MAQUINARIA pm");
                                                    consulta.append(" inner join TIPOS_EQUIPOS_MAQUINARIA tem on tem.COD_TIPO_EQUIPO=pm.COD_TIPO_EQUIPO");
                                                    consulta.append(" left outer join MATERIALES m on m.COD_MATERIAL=pm.COD_MATERIAL");
                                            consulta.append(" where pm.COD_MAQUINA=").append(maquinariaBean.getCodMaquina());
                                            consulta.append(" order by pm.NOMBRE_PARTE_MAQUINA");
                LOGGER.debug("consulta cargar partes maquinaria" + consulta.toString());
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res = st.executeQuery(consulta.toString());
                partesMaquinariaList=new ArrayList<PartesMaquinaria>();
                while (res.next())
                {
                    PartesMaquinaria nuevo=new PartesMaquinaria();
                    nuevo.getMateriales().setCodMaterial(res.getString("COD_MATERIAL"));
                    nuevo.getMateriales().setNombreMaterial(res.getString("NOMBRE_MATERIAL"));
                    nuevo.setCodParteMaquina(res.getInt("COD_PARTE_MAQUINA"));
                    nuevo.getTiposEquiposMaquinaria().setCodTipoEquipo(res.getString("COD_TIPO_EQUIPO"));
                    nuevo.getTiposEquiposMaquinaria().setNombreTipoEquipo(res.getString("NOMBRE_TIPO_EQUIPO"));
                    nuevo.setCodigo(res.getString("CODIGO"));
                    nuevo.setNombreParteMaquina(res.getString("NOMBRE_PARTE_MAQUINA"));
                    nuevo.setObsParteMaquina(res.getString("OBS_PARTE_MAQUINA"));
                    partesMaquinariaList.add(nuevo);
                }
                res.close();
                st.close();
            }
            catch (SQLException ex)
            {
                LOGGER.warn("error", ex);
            }
            catch (Exception ex)
            {
                LOGGER.warn("error", ex);
            }
            finally
            {
                this.cerrarConexion(con);
            }
        }
    //</editor-fold>

    //<editor-fold desc="funciones de proceso">
        public ManagedMaquinaria()
        {
            LOGGER=LogManager.getLogger("Mantenimiento");
            maquinariaBuscar=new Maquinaria();
            maquinariaBuscar.getAreasEmpresa().setCodAreaEmpresa("0");
            maquinariaBuscar.getTiposEquiposMaquinaria().setCodTipoEquipo("0");
            maquinariaBuscar.getEstadoReferencial().setCodEstadoRegistro("0");
        }
        private void cargarMarcasMaquinariaList()
        {
            try {
                con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("select mm.COD_MARCA_MAQUINARIA,mm.NOMBRE_MARCA_MAQUINARIA");
                                            consulta.append(" from MARCA_MAQUINARIA mm");
                                            consulta.append(" order by mm.NOMBRE_MARCA_MAQUINARIA");
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res = st.executeQuery(consulta.toString());
                marcasMaquinariaSelectList=new ArrayList<SelectItem>();
                while (res.next())
                {
                    marcasMaquinariaSelectList.add(new SelectItem(res.getInt("COD_MARCA_MAQUINARIA"),res.getString("NOMBRE_MARCA_MAQUINARIA")));
                }
                res.close();
                st.close();
            } catch (SQLException ex) {
                LOGGER.warn("error", ex);
            } catch (Exception ex) {
                LOGGER.warn("error", ex);
            } finally {
                this.cerrarConexion(con);
            }
        }
        public String editarMaquinaria_action()
        {
            for(Maquinaria bean:maquinariasList)
            {
                if(bean.getChecked())
                {
                    maquinariaEditar=bean;
                    this.cargarTodasAreasEmpresaSelectList();
                    break;
                }
            }
            return null;
        }
        public String eliminarMaquinaria_action()throws SQLException
        {
            mensaje="";
            for(Maquinaria bean:maquinariasList)
            {
                if(bean.getChecked())
                {
                    if(this.cantidadRegistrosUtilizanMaquinaria(bean)==0)
                    {
                        try
                        {
                            ManagedAccesoSistema managed=(ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
                            if(managed!=null)
                            {
                                con = Util.openConnection(con);
                                con.setAutoCommit(false);
                                SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");
                                StringBuilder consulta = new StringBuilder("INSERT INTO MAQUINARIAS_LOG");
                                                        consulta.append(" SELECT *,");
                                                            consulta.append(managed.getUsuarioModuloBean().getCodUsuarioGlobal());//personal transaccion
                                                            consulta.append(" ,GETDATE()");//fecha transaccion
                                                            consulta.append(" ,2");//tipo transaccion eliminacion
                                                        consulta.append(" FROM MAQUINARIAS m");
                                                        consulta.append(" where m.COD_MAQUINA=").append(bean.getCodMaquina());
                                LOGGER.debug("consulta guardar historico de edicion de maquinaria "+consulta.toString());
                                PreparedStatement pst = con.prepareStatement(consulta.toString());
                                if(pst.executeUpdate()>0)LOGGER.info("se registro el detalle de log eliminacion");
                                consulta=new StringBuilder("DELETE MAQUINARIAS");
                                        consulta.append(" WHERE COD_MAQUINA=").append(bean.getCodMaquina());
                                LOGGER.debug("consulta eliminar maquinaria "+consulta.toString());
                                pst=con.prepareStatement(consulta.toString());
                                if(pst.executeUpdate()>0)LOGGER.info("se elimino la maquinaria");
                                con.commit();
                                mensaje = "1";
                            }
                            else
                            {
                                mensaje="No se encuentra con sesion activa";
                            }
                        }
                        catch (SQLException ex)
                        {
                            mensaje = "Ocurrio un error al momento de guardar los pasos de preparado";
                            con.rollback();
                            LOGGER.warn(ex.getMessage());
                        }
                        catch (Exception ex)
                        {
                            mensaje = "Ocurrio un error al momento de guardar los pasos de preparado,verifique los datos introducidos";
                            LOGGER.warn(ex.getMessage());
                        }
                        finally
                        {
                            this.cerrarConexion(con);
                        }
                        mensaje="1";
                    }
                    else
                    {
                        mensaje="No se puede eliminar la maquinaria porque existen registros que lo utilizan";
                    }
                    break;
                }
            }
            if(mensaje.equals("1"))
            {
                this.cargarMaquinariasList();
            }
            return null;
        }
        public String guardarEdicionMaquinaria_action()throws SQLException
        {
            mensaje = "";
            try {
                con = Util.openConnection(con);
                con.setAutoCommit(false);
                SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");
                ManagedAccesoSistema managed=(ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
                if(managed!=null)
                {
                    StringBuilder consulta = new StringBuilder("INSERT INTO MAQUINARIAS_LOG");
                                            consulta.append(" SELECT *,");
                                                consulta.append(managed.getUsuarioModuloBean().getCodUsuarioGlobal());//personal transaccion
                                                consulta.append(" ,GETDATE()");//fecha transaccion
                                                consulta.append(" ,1");//tipo transaccion edicion
                                            consulta.append(" FROM MAQUINARIAS m");
                                            consulta.append(" where m.COD_MAQUINA=").append(maquinariaEditar.getCodMaquina());
                    LOGGER.debug("consulta guardar historico de edicion de maquinaria "+consulta.toString());
                    PreparedStatement pst=con.prepareStatement(consulta.toString());
                    if(pst.executeUpdate()>0)LOGGER.info("se registro el historico");
                    consulta=new StringBuilder("update MAQUINARIAS");
                            consulta.append(" SET CODIGO='").append(maquinariaEditar.getCodigo()).append("'");
                                    consulta.append(" ,NOMBRE_MAQUINA='").append(maquinariaEditar.getNombreMaquina()).append("'");
                                    consulta.append(" ,OBS_MAQUINA=?");
                                    if(maquinariaEditar.getFechaCompra()!=null)
                                            consulta.append(" ,FECHA_COMPRA='").append(sdf.format(maquinariaEditar.getFechaCompra())).append("'");
                                    consulta.append(" ,COD_TIPO_EQUIPO=").append(maquinariaEditar.getTiposEquiposMaquinaria().getCodTipoEquipo());
                                    consulta.append(" ,COD_AREA_EMPRESA=").append(maquinariaEditar.getAreasEmpresa().getCodAreaEmpresa());
                                    consulta.append(" ,COD_ESTADO_REGISTRO=").append(maquinariaEditar.getEstadoReferencial().getCodEstadoRegistro());
                                    consulta.append(" ,COD_MARCA_MAQUINARIA=").append(maquinariaEditar.getMarcaMaquinaria().getCodMarcaMaquinaria());
                                    consulta.append(" ,COD_MATERIAL=").append(maquinariaEditar.getMateriales().getCodMaterial());
                            consulta.append(" WHERE COD_MAQUINA=").append(maquinariaEditar.getCodMaquina());
                    LOGGER.debug("consulta editar maquinaria " + consulta.toString());
                    pst = con.prepareStatement(consulta.toString(), PreparedStatement.RETURN_GENERATED_KEYS);
                    pst.setString(1,maquinariaEditar.getObsMaquina());
                    if (pst.executeUpdate() > 0)LOGGER.info("se edito la maquinaria");
                    con.commit();
                    mensaje = "1";
                }
                else
                {
                    mensaje="No se encuentra con session activa";
                }
            }
            catch (SQLException ex)
            {
                mensaje = "Ocurrio un error al momento de guardar la edición de la maquinaria";
                con.rollback();
                LOGGER.warn(ex.getMessage());
            }
            catch (Exception ex)
            {
                mensaje = "Ocurrio un error al momento de guardar la edición de la maquinaria,verifique los datos introducidos";
                LOGGER.warn(ex.getMessage());
            }
            finally
            {
                this.cerrarConexion(con);
            }
            return null;
        }


        public String guardarNuevaMaquinaria_action()throws SQLException
        {
            mensaje = "";
            try {
                con = Util.openConnection(con);
                con.setAutoCommit(false);
                SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");
                StringBuilder consulta = new StringBuilder("INSERT INTO .MAQUINARIAS(CODIGO, NOMBRE_MAQUINA, FECHA_COMPRA,");
                                                    consulta.append(" COD_TIPO_EQUIPO, GMP, OBS_MAQUINA, COD_ESTADO_REGISTRO, COD_AREA_EMPRESA,COD_MARCA_MAQUINARIA,COD_MATERIAL)");
                                            consulta.append(" VALUES (");
                                                    consulta.append("'").append(maquinariaAgregar.getCodigo()).append("',");
                                                    consulta.append("'").append(maquinariaAgregar.getNombreMaquina()).append("',");
                                                    if(maquinariaAgregar.getFechaCompra()!=null)
                                                        consulta.append("'").append(sdf.format(maquinariaAgregar.getFechaCompra())).append("',");
                                                    else
                                                        consulta.append("null,");
                                                    consulta.append(maquinariaAgregar.getTiposEquiposMaquinaria().getCodTipoEquipo()).append(",");
                                                    consulta.append(maquinariaAgregar.isGMP()?1:0).append(",");
                                                    consulta.append("?,");//observacion
                                                    consulta.append("1,");//activo
                                                    consulta.append(maquinariaAgregar.getAreasEmpresa().getCodAreaEmpresa()).append(",");
                                                    consulta.append(maquinariaAgregar.getMarcaMaquinaria().getCodMarcaMaquinaria()).append(",");
                                                    consulta.append(maquinariaAgregar.getMateriales().getCodMaterial());
                                            consulta.append(")");
                LOGGER.debug("consulta registrar maquinaria" + consulta.toString());
                PreparedStatement pst = con.prepareStatement(consulta.toString(), PreparedStatement.RETURN_GENERATED_KEYS);
                pst.setString(1,maquinariaAgregar.getObsMaquina());
                if (pst.executeUpdate() > 0)LOGGER.info("se registro la maquinaria");
                con.commit();
                mensaje = "1";
            }
            catch (SQLException ex) {
                mensaje = "Ocurrio un error al momento de guardar la nueva maquinaria";
                con.rollback();
                LOGGER.warn(ex.getMessage());
            } catch (Exception ex) {
                mensaje = "Ocurrio un error al momento de guardar la nueva maquinaria,verifique los datos introducidos";
                LOGGER.warn(ex.getMessage());
            } finally {
                this.cerrarConexion(con);
            }
            return null;
        }

        public String getCargarAgregarMaquinaria()
        {
            maquinariaAgregar=new Maquinaria();
            this.cargarTodasAreasEmpresaSelectList();
            Materiales materialBuscar=new Materiales();
            materialBuscar.getGrupo().getCapitulo().setCodCapitulo(24);
            materialesSelectList=( new DaoMateriales() ).getMaterialesSelectList(materialBuscar);
            return null;
        }
        private void cargarTodasAreasEmpresaSelectList()
        {
            try {
                con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("select ae.COD_AREA_EMPRESA,ae.NOMBRE_AREA_EMPRESA");
                                        consulta.append(" from AREAS_EMPRESA ae");
                                        consulta.append(" where ae.COD_ESTADO_REGISTRO=1");
                                        consulta.append(" order by ae.NOMBRE_AREA_EMPRESA");
                LOGGER.debug("consulta cargar " + consulta);
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res = st.executeQuery(consulta.toString());
                areasEmpresaSelectList=new ArrayList<SelectItem>();
                while (res.next())
                {
                    areasEmpresaSelectList.add(new SelectItem(res.getString("COD_AREA_EMPRESA"),res.getString("NOMBRE_AREA_EMPRESA")));
                }
                res.close();
                st.close();
            } catch (SQLException ex) {
                LOGGER.warn("error", ex);
            } catch (Exception ex) {
                LOGGER.warn("error", ex);
            } finally {
                this.cerrarConexion(con);
            }
        }


        public String buscarMaquinarias_action()
        {
            this.cargarMaquinariasList();
            return null;
        }
        public String getCargarMaquinariasList()
        {
            this.cargarMarcasMaquinariaList();
            this.cargarMaquinariasList();
            this.cargarTiposEquipoSelectList();
            this.cargarAreasEmpresaSelectList();
            Materiales materialBuscar=new Materiales();
            materialBuscar.getGrupo().getCapitulo().setCodCapitulo(24);
            materialesSelectList=( new DaoMateriales() ).getMaterialesSelectList(materialBuscar);
            return null;
        }
        private void cargarTiposEquipoSelectList()
        {
            try
            {
                con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("select tem.COD_TIPO_EQUIPO,tem.NOMBRE_TIPO_EQUIPO");
                                        consulta.append(" from TIPOS_EQUIPOS_MAQUINARIA tem ");
                                        consulta.append(" where tem.COD_ESTADO_REGISTRO=1");
                                        consulta.append(" order by tem.NOMBRE_TIPO_EQUIPO");
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res = st.executeQuery(consulta.toString());
                tiposEquipoSelectList=new ArrayList<SelectItem>();
                while (res.next())
                {
                    tiposEquipoSelectList.add(new SelectItem(res.getString("COD_TIPO_EQUIPO"),res.getString("NOMBRE_TIPO_EQUIPO")));

                }
                res.close();
                st.close();
            }
            catch (SQLException ex)
            {
                LOGGER.warn("error", ex);
            }
            catch (Exception ex)
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
                                        consulta.append(" where ae.COD_AREA_EMPRESA in ");
                                                consulta.append(" (");
                                                        consulta.append(" select m.COD_AREA_EMPRESA from MAQUINARIAS m");
                                                consulta.append(" )");
                                        consulta.append(" order by ae.NOMBRE_AREA_EMPRESA");
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res = st.executeQuery(consulta.toString());
                areasEmpresaSelectList=new ArrayList<SelectItem>();
                while (res.next())
                {
                    areasEmpresaSelectList.add(new SelectItem(res.getString("COD_AREA_EMPRESA"),res.getString("NOMBRE_AREA_EMPRESA")));
                }
                res.close();
                st.close();
            } catch (SQLException ex) {
                LOGGER.warn("error", ex);
            } catch (Exception ex) {
                LOGGER.warn("error", ex);
            } finally {
                this.cerrarConexion(con);
            }
        }

        private void cargarMaquinariasList()
        {
            try
            {
                con=Util.openConnection(con);
                StringBuilder consulta=new StringBuilder("select m.COD_MAQUINA,m.NOMBRE_MAQUINA,m.OBS_MAQUINA,m.FECHA_COMPRA,");
                                        consulta.append(" er.NOMBRE_ESTADO_REGISTRO,m.CODIGO,m.COD_TIPO_EQUIPO,m.GMP,m.COD_ESTADO_REGISTRO,");
                                        consulta.append(" tem.NOMBRE_TIPO_EQUIPO,m.COD_AREA_EMPRESA,ae.NOMBRE_AREA_EMPRESA,");
                                        consulta.append(" m.FECHA_BAJA,m.COD_MARCA_MAQUINARIA,mm.NOMBRE_MARCA_MAQUINARIA");
                                        consulta.append(" ,m.COD_MATERIAL,mat.NOMBRE_MATERIAL");
                                consulta.append(" from maquinarias m");
                                        consulta.append(" inner join ESTADOS_REFERENCIALES er on er.COD_ESTADO_REGISTRO=m.COD_ESTADO_REGISTRO");
                                        consulta.append(" inner join AREAS_EMPRESA ae on ae.COD_AREA_EMPRESA=m.COD_AREA_EMPRESA");
                                        consulta.append(" inner join TIPOS_EQUIPOS_MAQUINARIA tem on tem.COD_TIPO_EQUIPO=m.COD_TIPO_EQUIPO");
                                        consulta.append(" left outer join MARCA_MAQUINARIA mm on mm.COD_MARCA_MAQUINARIA=m.COD_MARCA_MAQUINARIA");
                                        consulta.append(" left outer join MATERIALES mat on mat.COD_MATERIAL=m.COD_MATERIAL");
                                consulta.append(" where 1=1");
                                        if(maquinariaBuscar.getNombreMaquina().length()>0)
                                            consulta.append(" and m.NOMBRE_MAQUINA like '%").append(maquinariaBuscar.getNombreMaquina()).append("%'");
                                        if(maquinariaBuscar.getCodigo().length()>0)
                                            consulta.append(" and m.CODIGO like '%").append(maquinariaBuscar.getCodigo()).append("%'");
                                        if(!maquinariaBuscar.getTiposEquiposMaquinaria().getCodTipoEquipo().equals("0"))
                                            consulta.append(" and m.COD_TIPO_EQUIPO=").append(maquinariaBuscar.getTiposEquiposMaquinaria().getCodTipoEquipo());
                                        if(!maquinariaBuscar.getAreasEmpresa().getCodAreaEmpresa().equals("0"))
                                            consulta.append(" and m.COD_AREA_EMPRESA=").append(maquinariaBuscar.getAreasEmpresa().getCodAreaEmpresa());
                                        if(!maquinariaBuscar.getEstadoReferencial().getCodEstadoRegistro().equals("0"))
                                            consulta.append(" and m.COD_ESTADO_REGISTRO=").append(maquinariaBuscar.getEstadoReferencial().getCodEstadoRegistro());
                                consulta.append(" order by m.CODIGO,m.NOMBRE_MAQUINA");
                LOGGER.debug("consulta cargar maquinarias "+consulta);
                Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                ResultSet res=st.executeQuery(consulta.toString());
                maquinariasList=new ArrayList<Maquinaria>();
                while(res.next())
                {
                    Maquinaria nuevo=new Maquinaria();
                    nuevo.getMateriales().setCodMaterial(res.getString("COD_MATERIAL"));
                    nuevo.getMateriales().setNombreMaterial(res.getString("NOMBRE_MATERIAL"));
                    nuevo.getMarcaMaquinaria().setCodMarcaMaquinaria(res.getInt("COD_MARCA_MAQUINARIA"));
                    nuevo.getMarcaMaquinaria().setNombreMarcaMaquinaria(res.getString("NOMBRE_MARCA_MAQUINARIA"));
                    nuevo.setCodMaquina(res.getString("COD_MAQUINA"));
                    nuevo.setCodigo(res.getString("CODIGO"));
                    nuevo.setNombreMaquina(res.getString("NOMBRE_MAQUINA"));
                    nuevo.setObsMaquina(res.getString("OBS_MAQUINA"));
                    nuevo.setFechaCompra(res.getTimestamp("FECHA_COMPRA"));
                    nuevo.setFechaBaja(res.getTimestamp("FECHA_BAJA"));
                    nuevo.setGMP(res.getInt("GMP")>0);
                    nuevo.getEstadoReferencial().setCodEstadoRegistro(res.getString("COD_ESTADO_REGISTRO"));
                    nuevo.getEstadoReferencial().setNombreEstadoRegistro(res.getString("NOMBRE_ESTADO_REGISTRO"));
                    nuevo.getTiposEquiposMaquinaria().setCodTipoEquipo(res.getString("COD_TIPO_EQUIPO"));
                    nuevo.getTiposEquiposMaquinaria().setNombreTipoEquipo(res.getString("NOMBRE_TIPO_EQUIPO"));
                    nuevo.getAreasEmpresa().setCodAreaEmpresa(res.getString("COD_AREA_EMPRESA"));
                    nuevo.getAreasEmpresa().setNombreAreaEmpresa(res.getString("NOMBRE_AREA_EMPRESA"));
                    maquinariasList.add(nuevo);
                }
                res.close();
                st.close();
            }
            catch(SQLException ex)
            {
                LOGGER.warn("error", ex);
            }
            catch(Exception ex)
            {
                LOGGER.warn("error", ex);
            }
            finally
            {
                this.cerrarConexion(con);
            }
        }
        private int cantidadRegistrosUtilizanMaquinaria(Maquinaria maquinaria)
        {
            int cantidadRegistros=0;
            try {
                con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("select count(*) as cantidadRegistros");
                                           consulta.append(" from SOLICITUDES_MANTENIMIENTO s");
                                           consulta.append(" where s.COD_MAQUINARIA=").append(maquinaria.getCodMaquina());
                LOGGER.debug("consulta cargar cantidad registros utilizan maquinaria" + consulta.toString());
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res = st.executeQuery(consulta.toString());
                while (res.next())cantidadRegistros+=res.getInt("cantidadRegistros");
                res.close();
                st.close();
            }
            catch (SQLException ex)
            {
                LOGGER.warn("error", ex);
            }
            catch (Exception ex)
            {
                LOGGER.warn("error", ex);
            }
            finally
            {
                this.cerrarConexion(con);
            }
            return cantidadRegistros;
        }
    //</editor-fold>
    //<editor-fold desc="getter y setter">

        public List<SelectItem> getMarcasMaquinariaSelectList() {
            return marcasMaquinariaSelectList;
        }

        public void setMarcasMaquinariaSelectList(List<SelectItem> marcasMaquinariaSelectList) {
            this.marcasMaquinariaSelectList = marcasMaquinariaSelectList;
        }






        public Maquinaria getMaquinariaEditar() {
            return maquinariaEditar;
        }

        public void setMaquinariaEditar(Maquinaria maquinariaEditar) {
            this.maquinariaEditar = maquinariaEditar;
        }


        public List<Maquinaria> getMaquinariasList() {
            return maquinariasList;
        }

        public void setMaquinariasList(List<Maquinaria> maquinariasList) {
            this.maquinariasList = maquinariasList;
        }

        public String getMensaje() {
            return mensaje;
        }

        public void setMensaje(String mensaje) {
            this.mensaje = mensaje;
        }

        public Maquinaria getMaquinariaBuscar() {
            return maquinariaBuscar;
        }

        public void setMaquinariaBuscar(Maquinaria maquinariaBuscar) {
            this.maquinariaBuscar = maquinariaBuscar;
        }

        public List<SelectItem> getAreasEmpresaSelectList() {
            return areasEmpresaSelectList;
        }

        public void setAreasEmpresaSelectList(List<SelectItem> areasEmpresaSelectList) {
            this.areasEmpresaSelectList = areasEmpresaSelectList;
        }

        public List<SelectItem> getTiposEquipoSelectList() {
            return tiposEquipoSelectList;
        }

        public void setTiposEquipoSelectList(List<SelectItem> tiposEquipoSelectList) {
            this.tiposEquipoSelectList = tiposEquipoSelectList;
        }


        public Maquinaria getMaquinariaAgregar() {
        return maquinariaAgregar;
        }

        public List<SelectItem> getMaterialesSelectList() {
            return materialesSelectList;
        }

        public void setMaterialesSelectList(List<SelectItem> materialesSelectList) {
            this.materialesSelectList = materialesSelectList;
        }

        public void setMaquinariaAgregar(Maquinaria maquinariaAgregar) {
            this.maquinariaAgregar = maquinariaAgregar;
        }

        public HtmlDataTable getMaquinariaDataTable() {
            return maquinariaDataTable;
        }

        public void setMaquinariaDataTable(HtmlDataTable maquinariaDataTable) {
            this.maquinariaDataTable = maquinariaDataTable;
        }

        public List<PartesMaquinaria> getPartesMaquinariaList() {
            return partesMaquinariaList;
        }

        public void setPartesMaquinariaList(List<PartesMaquinaria> partesMaquinariaList) {
            this.partesMaquinariaList = partesMaquinariaList;
        }

        public PartesMaquinaria getPartesMaquinariaAgregar() {
            return partesMaquinariaAgregar;
        }

        public void setPartesMaquinariaAgregar(PartesMaquinaria partesMaquinariaAgregar) {
            this.partesMaquinariaAgregar = partesMaquinariaAgregar;
        }

        public PartesMaquinaria getPartesMaquinariaEditar() {
            return partesMaquinariaEditar;
        }

        public void setPartesMaquinariaEditar(PartesMaquinaria partesMaquinariaEditar) {
            this.partesMaquinariaEditar = partesMaquinariaEditar;
        }

        public Maquinaria getMaquinariaBean() {
            return maquinariaBean;
        }

        public void setMaquinariaBean(Maquinaria maquinariaBean) {
            this.maquinariaBean = maquinariaBean;
        }

    //</editor-fold>














    public String getCloseConnection() throws SQLException {
        LOGGER.debug("cierre innecesario");
        return "";
    }
    public double redondear(double numero, int decimales) {
        return Math.round(numero * Math.pow(10, decimales)) / Math.pow(10, decimales);
    }

}
