/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.web;




import com.cofar.bean.ProgramaProduccion;
import com.cofar.bean.ProgramaProduccionPeriodo;
import com.cofar.bean.SeguimientoPreparadoLote;

import com.cofar.bean.UsuariosModulos;
import com.cofar.util.Util;

import java.sql.Connection;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.text.NumberFormat;

import javax.faces.model.ListDataModel;
import javax.faces.model.SelectItem;
import org.richfaces.component.html.HtmlDataTable;

/**
 *
 * @author aquispe
 */

public class ManagedSeguimientoProcesosPorLote extends ManagedBean{
    private String loteBuscar="";
    private List programaProduccionPeriodoList = new ArrayList();
    private ProgramaProduccion programaProduccionbean=new ProgramaProduccion();
    private List<SeguimientoPreparadoLote> seguimientoPreparadoLoteList=new ArrayList<SeguimientoPreparadoLote>();
    private HtmlDataTable progProdResultadoAnalisDataTable = new HtmlDataTable();
    private HtmlDataTable progPerEspecificacionesProcesos=new HtmlDataTable();
    private ProgramaProduccion programaProduccionTableta=new ProgramaProduccion();
    private List<SelectItem> programasPeriodoListSelect=new ArrayList<SelectItem>();
    private List<SelectItem> componentesProdListSelect=new ArrayList<SelectItem>();
    private List<SelectItem> areasEmpresaListSelect=new ArrayList<SelectItem>();
    private List<SelectItem> estadosProgProdListSelect=new ArrayList<SelectItem>();
    private ListDataModel programaProduccionDataModel=new ListDataModel();
    private UsuariosModulos usuariosModulo=new UsuariosModulos();
    private String mensaje="";
    public ManagedSeguimientoProcesosPorLote() {
    }
     public String actionVerficarUsuario(){
        mensaje="";
        Connection con=null;
        try {
            con=Util.openConnection(con);
            String  sql="select um.cod_personal,um.cod_modulo,p.nombre_pila,";
            sql+=" p.ap_paterno_personal,p.ap_materno_personal,p.cod_area_empresa ";
            sql+=" from usuarios_modulos um,personal p  ";
            sql+=" where um.cod_personal=p.cod_personal ";
            sql+=" and um.cod_modulo='6'";
            sql+= " and  um.nombre_usuario='"+usuariosModulo.getNombreUsuario()+"'";
            sql+= " and  um.contrasena_usuario='"+usuariosModulo.getContraseniaUsuario()+"'";
            System.out.println("sql:"+sql);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(sql);
            if(rs.next()){
                usuariosModulo.setCodUsuarioGlobal(rs.getString("cod_personal"));
                usuariosModulo.setNombrePilaUsuarioGlobal(rs.getString("nombre_pila"));
                usuariosModulo.setApPaternoUsuarioGlobal(rs.getString("ap_paterno_personal"));
                usuariosModulo.setApMaternoUsuarioGlobal(rs.getString("ap_materno_personal"));
                mensaje="";
            }
            else
            {
                mensaje="Usuario y/o Contraseña Incorecta";
            }
            rs.close();
            st.close();
            con.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
         System.out.println("fhosdsds");
            return null;

    }



    public String getCargarProgProdTableta()
    {
        this.cargarDatosFiltro();
        return null;
    }
    private void cargarDatosFiltro()
    {
        try
        {
            Connection con1=null;
            con1=Util.openConnection(con1);
            Statement st=con1.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select ppp.COD_PROGRAMA_PROD,ppp.NOMBRE_PROGRAMA_PROD from PROGRAMA_PRODUCCION_PERIODO ppp where ppp.COD_ESTADO_PROGRAMA<>4 and ISNULL(ppp.COD_TIPO_PRODUCCION,1) in (1)"+
                            " order by ppp.COD_PROGRAMA_PROD";
            ResultSet res=st.executeQuery(consulta);
            programasPeriodoListSelect.clear();
            programasPeriodoListSelect.add(new SelectItem("0","-TODOS-"));
            while(res.next())
            {
                 programasPeriodoListSelect.add(new SelectItem(res.getString("COD_PROGRAMA_PROD"),res.getString("NOMBRE_PROGRAMA_PROD")));
            }
            consulta="select cp.COD_COMPPROD,cp.nombre_prod_semiterminado from COMPONENTES_PROD cp  order by cp.nombre_prod_semiterminado";
            res=st.executeQuery(consulta);
            componentesProdListSelect.clear();
            componentesProdListSelect.add(new SelectItem("0","-TODOS-"));
            while(res.next())
            {
                 componentesProdListSelect.add(new SelectItem(res.getString("COD_COMPPROD"),res.getString("nombre_prod_semiterminado")));
            }
            consulta="select epp.COD_ESTADO_PROGRAMA_PROD,epp.NOMBRE_ESTADO_PROGRAMA_PROD from ESTADOS_PROGRAMA_PRODUCCION epp order by epp.NOMBRE_ESTADO_PROGRAMA_PROD";
            res=st.executeQuery(consulta);
            estadosProgProdListSelect.clear();
            estadosProgProdListSelect.add(new SelectItem("0","-TODOS-"));
            while(res.next())
            {
                 estadosProgProdListSelect.add(new SelectItem(res.getString("COD_ESTADO_PROGRAMA_PROD"),res.getString("NOMBRE_ESTADO_PROGRAMA_PROD")));
            }
            consulta="select ae.COD_AREA_EMPRESA,ae.NOMBRE_AREA_EMPRESA"+
                     " from AREAS_EMPRESA ae inner join AREAS_FABRICACION af on ae.COD_AREA_EMPRESA=af.COD_AREA_FABRICACION"+
                     " order by ae.NOMBRE_AREA_EMPRESA";
            res=st.executeQuery(consulta);
            areasEmpresaListSelect.clear();
            areasEmpresaListSelect.add(new SelectItem("0","-TODOS-"));
            while(res.next())
            {
                 areasEmpresaListSelect.add(new SelectItem(res.getString("COD_AREA_EMPRESA"),res.getString("NOMBRE_AREA_EMPRESA")));
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

    public String getCargarProgProdPeriodo(){
        loteBuscar="";
       this.cargarProgramasProduccion();
        return null;
    }

    private void cargarProgramasProduccion()
   {
        try {

            Connection con = null;
            con = Util.openConnection(con);
            Statement st = con.createStatement();
            String consulta = " SELECT PP.COD_PROGRAMA_PROD,PP.NOMBRE_PROGRAMA_PROD,PP.OBSERVACIONES,(SELECT EP.NOMBRE_ESTADO_PROGRAMA_PROD FROM ESTADOS_PROGRAMA_PRODUCCION EP WHERE EP.COD_ESTADO_PROGRAMA_PROD = PP.COD_ESTADO_PROGRAMA) NOMBRE_ESTADO_PROGRAMA_PROD FROM PROGRAMA_PRODUCCION_PERIODO PP WHERE PP.COD_ESTADO_PROGRAMA<>4 and ISNULL(PP.COD_TIPO_PRODUCCION,1) not in (2)";
            if(!loteBuscar.equals(""))
            {
                consulta+=" and PP.COD_PROGRAMA_PROD in (select pp1.COD_PROGRAMA_PROD from PROGRAMA_PRODUCCION pp1 where pp1.COD_LOTE_PRODUCCION like '%"+loteBuscar+"%')";
            }
            System.out.println("consulta cargar Periodos");
            ResultSet rs = st.executeQuery(consulta);
            programaProduccionPeriodoList.clear();
            while(rs.next()){
                ProgramaProduccionPeriodo programaProduccionPeriodo = new ProgramaProduccionPeriodo();
                programaProduccionPeriodo.setCodProgramaProduccion(rs.getString("COD_PROGRAMA_PROD"));
                programaProduccionPeriodo.setNombreProgramaProduccion(rs.getString("NOMBRE_PROGRAMA_PROD"));
                programaProduccionPeriodo.getEstadoProgramaProduccion().setNombreEstadoProgramaProd(rs.getString("NOMBRE_ESTADO_PROGRAMA_PROD"));
                programaProduccionPeriodo.setObsProgramaProduccion(rs.getString("OBSERVACIONES"));
                programaProduccionPeriodoList.add(programaProduccionPeriodo);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
   }

    public double redondear( double numero, int decimales ) {
        return Math.round(numero*Math.pow(10,decimales))/Math.pow(10,decimales);
    }
    public String buscarLotesProgramaProd_action()
    {
        this.cargarProgramasProdRegistroTablet();
        return null;
    }
    private void cargarProgramasProdRegistroTablet()
    {
        Connection con1=null;
        try
        {
            con1=Util.openConnection(con1);
            Statement st=con1.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select cp.COD_COMPPROD,cp.nombre_prod_semiterminado,pp.COD_LOTE_PRODUCCION,sum(pp.CANT_LOTE_PRODUCCION) as cantidadLote,"+
                            " epp.NOMBRE_ESTADO_PROGRAMA_PROD,ae.NOMBRE_AREA_EMPRESA,ae.COD_AREA_EMPRESA"+
                            " from PROGRAMA_PRODUCCION pp inner join PROGRAMA_PRODUCCION_PERIODO ppp"+
                            " on pp.COD_PROGRAMA_PROD=ppp.COD_PROGRAMA_PROD"+
                            " inner join COMPONENTES_PROD cp on cp.COD_COMPPROD=pp.COD_COMPPROD"+
                            " inner join AREAS_EMPRESA ae on ae.COD_AREA_EMPRESA=cp.COD_AREA_EMPRESA"+
                            " inner join ESTADOS_PROGRAMA_PRODUCCION epp on epp.COD_ESTADO_PROGRAMA_PROD=pp.COD_ESTADO_PROGRAMA"+
                            " where ppp.COD_ESTADO_PROGRAMA<>4 and ISNULL(ppp.COD_TIPO_PRODUCCION,1) in (1)"+
                            (programaProduccionTableta.getCodProgramaProduccion().equals("0")?"":" and pp.COD_PROGRAMA_PROD='"+programaProduccionTableta.getCodProgramaProduccion()+"'")+
                            (programaProduccionTableta.getCodLoteProduccion().equals("")?"":" and pp.COD_LOTE_PRODUCCION  like '%"+programaProduccionTableta.getCodLoteProduccion()+"%'")+
                            //(programaProduccionTableta.getFormulaMaestra().getComponentesProd().getAreasEmpresa().getCodAreaEmpresa().equals("0")?"":
                            //    " and cp.COD_AREA_EMPRESA='"+programaProduccionTableta.getFormulaMaestra().getComponentesProd().getAreasEmpresa().getCodAreaEmpresa()+"'")+
                            //(programaProduccionTableta.getEstadoProgramaProduccion().getCodEstadoProgramaProd().equals("0")?"": " and pp.COD_ESTADO_PROGRAMA='"+programaProduccionTableta.getEstadoProgramaProduccion().getCodEstadoProgramaProd()+"'")+
                            //(programaProduccionTableta.getFormulaMaestra().getComponentesProd().getCodCompprod().equals("0")?"": " and pp.COD_COMPPROD='"+programaProduccionTableta.getFormulaMaestra().getComponentesProd().getCodCompprod()+"'")+
                            "group by cp.COD_COMPPROD,cp.nombre_prod_semiterminado,pp.COD_LOTE_PRODUCCION,epp.NOMBRE_ESTADO_PROGRAMA_PROD,ae.COD_AREA_EMPRESA"+
                            " ,ae.NOMBRE_AREA_EMPRESA"+
                            " order by cp.nombre_prod_semiterminado,pp.COD_LOTE_PRODUCCION";
            System.out.println("consulta cargar programa Produccion"+consulta);
            ResultSet res=st.executeQuery(consulta);
            programaProduccionDataModel.setWrappedData(new ArrayList());
            List listaprogramas=new ArrayList();
            while(res.next())
            {
                    ProgramaProduccion nuevo=new ProgramaProduccion();
                    nuevo.setCodLoteProduccion(res.getString("COD_LOTE_PRODUCCION"));
                    nuevo.setCantidadLote(res.getDouble("cantidadLote"));
                    nuevo.getFormulaMaestra().getComponentesProd().setCodCompprod(res.getString("COD_COMPPROD"));
                    nuevo.getFormulaMaestra().getComponentesProd().setNombreProdSemiterminado(res.getString("nombre_prod_semiterminado"));
                    nuevo.getFormulaMaestra().getComponentesProd().getAreasEmpresa().setNombreAreaEmpresa(res.getString("NOMBRE_AREA_EMPRESA"));
                    nuevo.getFormulaMaestra().getComponentesProd().getAreasEmpresa().setCodAreaEmpresa(res.getString("COD_AREA_EMPRESA"));
                    nuevo.getEstadoProgramaProduccion().setNombreEstadoProgramaProd(res.getString("NOMBRE_ESTADO_PROGRAMA_PROD"));
                    listaprogramas.add(nuevo);
            }
            programaProduccionDataModel.setWrappedData(listaprogramas);
            res.close();
            st.close();
            con1.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
    }
    public String  getCogerCodProgProdPeriodo(){
        
        try {
            String consulta = "";
            Connection con =null;
            con=Util.openConnection(con);
            consulta="select cp.COD_FORMA,cp.COD_COMPPROD,cp.nombre_prod_semiterminado,pp.COD_LOTE_PRODUCCION,"+
                       " pp.CANT_LOTE_PRODUCCION,ae.NOMBRE_AREA_EMPRESA,ae.COD_AREA_EMPRESA,epp.NOMBRE_ESTADO_PROGRAMA_PROD"+
                       " ,cp.COD_PROD,p.nombre_prod,ppp.COD_PROGRAMA_PROD,ppp.NOMBRE_PROGRAMA_PROD" +
                       " ,isnull(cpr.COD_RECETA_ESTERILIZACION_CALOR,0) as COD_RECETA_ESTERILIZACION_CALOR"+
                       " from PROGRAMA_PRODUCCION pp inner join FORMULA_MAESTRA fm on"+
                       " pp.COD_FORMULA_MAESTRA=fm.COD_FORMULA_MAESTRA inner join COMPONENTES_PROD cp"+
                       " on cp.COD_COMPPROD=fm.COD_COMPPROD inner join ESTADOS_PROGRAMA_PRODUCCION epp"+
                       " on epp.COD_ESTADO_PROGRAMA_PROD=pp.COD_ESTADO_PROGRAMA"+
                       " inner join AREAS_EMPRESA ae on ae.COD_AREA_EMPRESA=cp.COD_AREA_EMPRESA"+
                       " inner join PRODUCTOS p on p.cod_prod=cp.COD_PROD" +
                       " inner join PROGRAMA_PRODUCCION_PERIODO ppp on pp.COD_PROGRAMA_PROD=ppp.COD_PROGRAMA_PROD" +
                       " left outer join COMPONENTES_PROD_RECETA cpr on cpr.COD_COMPROD=pp.COD_COMPPROD"+
                       " where pp.COD_ESTADO_PROGRAMA in (2,5,6,7)"+
                       (programaProduccionbean.getCodProgramaProduccion().equals("")?"":" and pp.cod_programa_prod="+programaProduccionbean.getCodProgramaProduccion())+
                     (programaProduccionbean.getCodLoteProduccion().equals("")?"":" and pp.cod_lote_produccion='"+programaProduccionbean.getCodLoteProduccion()+"'")+
                       " order by ppp.COD_PROGRAMA_PROD,pp.COD_LOTE_PRODUCCION,cp.nombre_prod_semiterminado";
            System.out.println("consulta lotes "+consulta);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta);
            seguimientoPreparadoLoteList.clear();
            String codLoteCabecera="";
            int contLote=0;
            SeguimientoPreparadoLote nuevo=new SeguimientoPreparadoLote();
            Statement stDetalle=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet resDetalle=null;
            while(res.next())
            {
                if(!codLoteCabecera.equals(res.getString("COD_LOTE_PRODUCCION")+" "+res.getString("NOMBRE_PROGRAMA_PROD")))
                {
                    if(!codLoteCabecera.equals(""))
                    {
                        if(contLote>1)
                        {
                            String[]  codProd=nuevo.getProgramaProduccion().getFormulaMaestra().getComponentesProd().getCodCompprod().split(",");
                            if(codProd.length==2)
                            {
                                consulta="select cp.COD_COMPPROD,cp.nombre_prod_semiterminado from COMPONENTES_PROD_MIX cpm inner join COMPONENTES_PROD cp"+
                                                " on cp.COD_COMPPROD=cpm.COD_COMPROD_MIX"+
                                                " where ((cpm.COD_COMPROD1='"+codProd[0]+"' and cpm.COD_COMPROD2='"+codProd[1]+"') or"+
                                                " (cpm.COD_COMPROD1='"+codProd[1]+"' and cpm.COD_COMPROD2='"+codProd[0]+"'))";
                                System.out.println("consulta buscar mix "+consulta);
                                resDetalle=stDetalle.executeQuery(consulta);
                                if(resDetalle.next())
                                {
                                    nuevo.getProgramaProduccion().getFormulaMaestra().getComponentesProd().setCodCompprod(resDetalle.getString("COD_COMPPROD"));
                                    nuevo.getProgramaProduccion().getFormulaMaestra().getComponentesProd().setNombreProdSemiterminado(resDetalle.getString("nombre_prod_semiterminado"));
                                }
                                else
                                {
                                    nuevo.getProgramaProduccion().getFormulaMaestra().getComponentesProd().setCodCompprod("");
                                    nuevo.getProgramaProduccion().getFormulaMaestra().getComponentesProd().setNombreProdSemiterminado("No definido"+
                                    "("+nuevo.getProgramaProduccion().getFormulaMaestra().getComponentesProd().getNombreProdSemiterminado()+")");
                                }

                            }
                            if(codProd.length>2)
                            {
                                nuevo.getProgramaProduccion().getFormulaMaestra().getComponentesProd().setCodCompprod("");
                                nuevo.getProgramaProduccion().getFormulaMaestra().getComponentesProd().setNombreProdSemiterminado("No definido"+
                                "("+nuevo.getProgramaProduccion().getFormulaMaestra().getComponentesProd().getNombreProdSemiterminado()+")");
                            }
                            
                        }
                        seguimientoPreparadoLoteList.add(nuevo);
                    }
                    
                    codLoteCabecera=res.getString("COD_LOTE_PRODUCCION")+" "+res.getString("NOMBRE_PROGRAMA_PROD");
                    nuevo=new SeguimientoPreparadoLote();
                    nuevo.getProgramaProduccion().setCodLoteProduccion(res.getString("COD_LOTE_PRODUCCION"));
                    contLote=0;
                }
                contLote++;
                nuevo.setChecked(res.getInt("COD_RECETA_ESTERILIZACION_CALOR")>0);
                nuevo.getProgramaProduccion().getProgramaProduccionPeriodo().setCodProgramaProduccion(res.getString("COD_PROGRAMA_PROD"));
                nuevo.getProgramaProduccion().getProgramaProduccionPeriodo().setNombreProgramaProduccion(res.getString("NOMBRE_PROGRAMA_PROD"));
                nuevo.getProgramaProduccion().getFormulaMaestra().getComponentesProd().getAreasEmpresa().setCodAreaEmpresa(res.getString("COD_AREA_EMPRESA"));
                nuevo.getProgramaProduccion().getFormulaMaestra().getComponentesProd().getAreasEmpresa().setNombreAreaEmpresa(res.getString("NOMBRE_AREA_EMPRESA"));
                nuevo.getProgramaProduccion().setCantidadLote(nuevo.getProgramaProduccion().getCantidadLote()+res.getDouble("CANT_LOTE_PRODUCCION"));
                nuevo.getProgramaProduccion().getFormulaMaestra().getComponentesProd().setCodCompprod(nuevo.getProgramaProduccion().getFormulaMaestra().getComponentesProd().getCodCompprod()+
                (contLote>1?",":"")+res.getString("COD_COMPPROD"));
                nuevo.getProgramaProduccion().getFormulaMaestra().getComponentesProd().setNombreProdSemiterminado(
                nuevo.getProgramaProduccion().getFormulaMaestra().getComponentesProd().getNombreProdSemiterminado()+
                (contLote>1?",":"")+res.getString("nombre_prod_semiterminado"));
                nuevo.getProgramaProduccion().getFormulaMaestra().getComponentesProd().getForma().setCodForma(res.getString("COD_FORMA"));
                nuevo.getProgramaProduccion().getEstadoProgramaProduccion().setNombreEstadoProgramaProd(res.getString("NOMBRE_ESTADO_PROGRAMA_PROD"));
                nuevo.getProgramaProduccion().getFormulaMaestra().getComponentesProd().getProducto().setCodProducto(
                nuevo.getProgramaProduccion().getFormulaMaestra().getComponentesProd().getProducto().getCodProducto()+(contLote>1?",":"")+res.getString("COD_PROD"));
                nuevo.getProgramaProduccion().getFormulaMaestra().getComponentesProd().getProducto().setNombreProducto(res.getString("nombre_prod"));
            }
            if(!codLoteCabecera.equals(""))
            {
                if(contLote>1)
                {

                        String[]  codProd=nuevo.getProgramaProduccion().getFormulaMaestra().getComponentesProd().getCodCompprod().split(",");
                        if(codProd.length==2)
                        {
                            consulta="select cp.COD_COMPPROD,cp.nombre_prod_semiterminado from COMPONENTES_PROD_MIX cpm inner join COMPONENTES_PROD cp"+
                                            " on cp.COD_COMPPROD=cpm.COD_COMPROD_MIX"+
                                            " where ((cpm.COD_COMPROD1='"+codProd[0]+"' and cpm.COD_COMPROD2='"+codProd[1]+"') or"+
                                            " (cpm.COD_COMPROD1='"+codProd[1]+"' and cpm.COD_COMPROD2='"+codProd[0]+"'))";
                            System.out.println("consulta buscar mix "+consulta);
                            resDetalle=stDetalle.executeQuery(consulta);
                            if(resDetalle.next())
                            {
                                nuevo.getProgramaProduccion().getFormulaMaestra().getComponentesProd().setCodCompprod(resDetalle.getString("COD_COMPPROD"));
                                nuevo.getProgramaProduccion().getFormulaMaestra().getComponentesProd().setNombreProdSemiterminado(resDetalle.getString("nombre_prod_semiterminado"));
                            }
                            else
                            {
                                nuevo.getProgramaProduccion().getFormulaMaestra().getComponentesProd().setCodCompprod("");
                                nuevo.getProgramaProduccion().getFormulaMaestra().getComponentesProd().setNombreProdSemiterminado("No definido"+
                                "("+nuevo.getProgramaProduccion().getFormulaMaestra().getComponentesProd().getNombreProdSemiterminado()+")");
                            }

                        }
                        if(codProd.length>2)
                        {
                            nuevo.getProgramaProduccion().getFormulaMaestra().getComponentesProd().setCodCompprod("");
                            nuevo.getProgramaProduccion().getFormulaMaestra().getComponentesProd().setNombreProdSemiterminado("No definido"+
                            "("+nuevo.getProgramaProduccion().getFormulaMaestra().getComponentesProd().getNombreProdSemiterminado()+")");
                        }
                }
                seguimientoPreparadoLoteList.add(nuevo);
            }
            res.close();
            st.close();
            con.close();

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return"";
    }

    public String buscarLote_Action()
   {
        programaProduccionbean.setCodProgramaProduccion("");
        programaProduccionbean.setCodLoteProduccion(loteBuscar);
       //this.cargarProgramasProduccion();
       return null;
   }
    public String seleccionarProgramaPeriodo_action()
    {
        ProgramaProduccionPeriodo programa=(ProgramaProduccionPeriodo) progPerEspecificacionesProcesos.getRowData();
        programaProduccionbean.setCodProgramaProduccion(programa.getCodProgramaProduccion());
        programaProduccionbean.setCodLoteProduccion("");
        return null;
    }

    public String getLoteBuscar() {
        return loteBuscar;
    }

    public void setLoteBuscar(String loteBuscar) {
        this.loteBuscar = loteBuscar;
    }

    public List getProgramaProduccionPeriodoList() {
        return programaProduccionPeriodoList;
    }

    public void setProgramaProduccionPeriodoList(List programaProduccionPeriodoList) {
        this.programaProduccionPeriodoList = programaProduccionPeriodoList;
    }

    public List<SeguimientoPreparadoLote> getSeguimientoPreparadoLoteList() {
        return seguimientoPreparadoLoteList;
    }

    public void setSeguimientoPreparadoLoteList(List<SeguimientoPreparadoLote> seguimientoPreparadoLoteList) {
        this.seguimientoPreparadoLoteList = seguimientoPreparadoLoteList;
    }

    public ProgramaProduccion getProgramaProduccionbean() {
        return programaProduccionbean;
    }

    public void setProgramaProduccionbean(ProgramaProduccion programaProduccionbean) {
        this.programaProduccionbean = programaProduccionbean;
    }

    public HtmlDataTable getProgProdResultadoAnalisDataTable() {
        return progProdResultadoAnalisDataTable;
    }

    public void setProgProdResultadoAnalisDataTable(HtmlDataTable progProdResultadoAnalisDataTable) {
        this.progProdResultadoAnalisDataTable = progProdResultadoAnalisDataTable;
    }

    public HtmlDataTable getProgPerEspecificacionesProcesos() {
        return progPerEspecificacionesProcesos;
    }

    public void setProgPerEspecificacionesProcesos(HtmlDataTable progPerEspecificacionesProcesos) {
        this.progPerEspecificacionesProcesos = progPerEspecificacionesProcesos;
    }

    public List<SelectItem> getAreasEmpresaListSelect() {
        return areasEmpresaListSelect;
    }

    public void setAreasEmpresaListSelect(List<SelectItem> areasEmpresaListSelect) {
        this.areasEmpresaListSelect = areasEmpresaListSelect;
    }

    public List<SelectItem> getComponentesProdListSelect() {
        return componentesProdListSelect;
    }

    public void setComponentesProdListSelect(List<SelectItem> componentesProdListSelect) {
        this.componentesProdListSelect = componentesProdListSelect;
    }

    public List<SelectItem> getEstadosProgProdListSelect() {
        return estadosProgProdListSelect;
    }

    public void setEstadosProgProdListSelect(List<SelectItem> estadosProgProdListSelect) {
        this.estadosProgProdListSelect = estadosProgProdListSelect;
    }

    public ListDataModel getProgramaProduccionDataModel() {
        return programaProduccionDataModel;
    }

    public void setProgramaProduccionDataModel(ListDataModel programaProduccionDataModel) {
        this.programaProduccionDataModel = programaProduccionDataModel;
    }

    public ProgramaProduccion getProgramaProduccionTableta() {
        return programaProduccionTableta;
    }

    public void setProgramaProduccionTableta(ProgramaProduccion programaProduccionTableta) {
        this.programaProduccionTableta = programaProduccionTableta;
    }

    public List<SelectItem> getProgramasPeriodoListSelect() {
        return programasPeriodoListSelect;
    }

    public void setProgramasPeriodoListSelect(List<SelectItem> programasPeriodoListSelect) {
        this.programasPeriodoListSelect = programasPeriodoListSelect;
    }

    public String getMensaje() {
        return mensaje;
    }

    public void setMensaje(String mensaje) {
        this.mensaje = mensaje;
    }

    public UsuariosModulos getUsuariosModulo() {
        return usuariosModulo;
    }

    public void setUsuariosModulo(UsuariosModulos usuariosModulo) {
        this.usuariosModulo = usuariosModulo;
    }
    
}
