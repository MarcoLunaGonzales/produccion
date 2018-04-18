<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@taglib prefix="ws" uri="http://isawi.org/ws"%>
<f:view>
    
    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
            <script type="text/javascript" src="../js/general.js" ></script>
             <style>
                .subCabecera
                {
                    background-color:#9d5a9e;
                    color:white;
                    font-weight:bold;
                }
                .headerLocal{
                    background-image:none;
                    background-color:#9d5f9f;
                    font-weight:bold;
                }
                .celdaVersion{
                    background-color:#eeeeee;
                }
            </style>
            <script>
                
                function getCodigoReactivo(codigo){
                 //  alert(codigo);
                   location='../formulaMaestraDetalleMPReactivos/navegador_formula_maestraMP.jsf?codigo='+codigo;
                }
                
                function getCodigo(codigo){
                 //  alert(codigo);
                   location='../formulaMaestraDetalleMP/navegador_formula_maestraMP.jsf?codigo='+codigo;
                }
                function getCodigoActividad(codigo){
                //   alert(codigo);
                   location='../actividades_formula_maestra/navegador_actividades_formula.jsf?codigo='+codigo;
                }
                function getCodigoActividadProduccion(codigoFormulaMaestra,codAreaEmpresa){
                //   alert(codigo);
                   location='../actividades_formula_maestra/navegador_actividades_formula.jsf?codigo='+codigoFormulaMaestra+'&codAreaEmpresa='+codAreaEmpresa;
                }
                function getCodigoActividadMicrobiologia(codigoFormulaMaestra,codAreaEmpresa){
                //   alert(codigo);
                   location='../actividades_formula_maestra/navegador_actividades_formula.jsf?codigo='+codigoFormulaMaestra+'&codAreaEmpresa='+codAreaEmpresa;
                }
                function getCodigoActividadControlDeCalidad(codigoFormulaMaestra,codAreaEmpresa){
                //   alert(codigo);
                   location='../actividades_formula_maestra/navegador_actividades_formula.jsf?codigo='+codigoFormulaMaestra+'&codAreaEmpresa='+codAreaEmpresa;
                }
                function getCodigoActividadAcondicionamiento(codigoFormulaMaestra,codAreaEmpresa){
                //   alert(codigo);
                   location='../actividades_formula_maestra/navegador_actividades_formula.jsf?codigo='+codigoFormulaMaestra+'&codAreaEmpresa='+codAreaEmpresa;
                }
                function getCodigoFasePreparado(codigoFormulaMaestra){
                //   alert(codigo);
                   location='../formulaMaestraPreparado/navegadorFormulaMaestraPreparado.jsf?codigoFormulaMaestra='+codigoFormulaMaestra;
                }
                function getCodigoArea(codigo){
                //   alert(codigo);
                   location='../formulaMaestraEP/navegador_formula_maestraEP.jsf?codigo='+codigo;
                }
                function getCodigoES(codigo){
                 //  alert(codigo);
                   location='../formulaMaestraES/navegador_formula_maestraES.jsf?codigo='+codigo;
                }
                function getCodigoMatProm(codigo){
                //   alert(codigo);
                   location='../formulaMaestraDetalleMPROM/navegador_formula_maestraMPROM.jsf?codigo='+codigo;
                }
                function editarItem(nametable){
                   var count=0;
                   var elements=document.getElementById(nametable);
                   var rowsElement=elements.rows;
                   for(var i=2;i<rowsElement.length;i++){
                    var cellsElement=rowsElement[i].cells;
                    var cel=cellsElement[0];
                    if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                          if(cel.getElementsByTagName('input')[0].checked){
                           count++;
                         }
                         
                     }
                      
                   }
                   if(count==1){
                      return true;
                   } else if(count==0){
                       alert('No escogio ningun registro');
                       return false;
                   }
                   else if(count>1){
                       alert('Solo puede escoger un registro');
                       return false;
                   }                                      
                }


                function asignar(nametable){

                   var count=0;
                   var elements=document.getElementById(nametable);
                   var rowsElement=elements.rows;
                   for(var i=1;i<rowsElement.length;i++){
                    var cellsElement=rowsElement[i].cells;
                    var cel=cellsElement[0];
                    alert('hola');
                    if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                          if(cel.getElementsByTagName('input')[0].checked){
                           count++;
                         }                         
                     }                      
                   }
                    if(count==0){
                       alert('No selecciono ningun Registro');
                       return false;
                   }else{
                       if(confirm('Desea Asignar como Area Raiz')){
                            if(confirm('Esta seguro de Asignar como Area Raiz')){
                                 return true;
                        }else{
                            return false;
                        }
                    }else{
                        return false;
                    }
                   
                   }
                   
                }          
            function eliminar(nametable){
               var count1=0;
               var elements1=document.getElementById(nametable);
               var rowsElement1=elements1.rows;
               //alert(rowsElement1.length);            
               for(var i=1;i<rowsElement1.length;i++){
                    var cellsElement1=rowsElement1[i].cells;
                    var cel1=cellsElement1[0];
                    if(cel1.getElementsByTagName('input').length>0){
                        if(cel1.getElementsByTagName('input')[0].type=='checkbox'){
                          if(cel1.getElementsByTagName('input')[0].checked){
                               count1++;
                           }
                        }
                    }
                    
               }
               //alert(count1);
               if(count1==0){
                    alert('No escogio ningun registro');
                    return false;
               }else{
                
                
                    if(confirm('Desea Eliminar el Registro')){
                        if(confirm('Esta seguro de Eliminar el Registro')){
                            /*var count=0;
                            var elements=document.getElementById(nametable);
                            var rowsElement=elements.rows;
                            
                            for(var i=0;i<rowsElement.length;i++){
                                var cellsElement=rowsElement[i].cells;
                                var cel=cellsElement[0];
                                if(cel.getElementsByTagName('input').length>0){
                                    if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                                        if(cel.getElementsByTagName('input')[0].checked){
                                            count++;
                                        }
                                    }
                                }

                            }*/
                            /*if(count1==0){
                            //alert('No escogio ningun registro');
                            return false;
                            }*/
                            //var cantidadeliminar=document.getElementById('form1:cantidadeliminar');
                            //cantidadeliminar.value=count;
                            return true;
                        }else{
                            return false;
                        }
                    }else{
                        return false;
                    }
                }
           }                
            function verificarTransaccionUsuario(codPersonal,celda)
            {
                var contIndex=parseInt(celda.parentNode.parentNode.rowIndex-1);
                var permiso=false;
                if(parseInt(celda.parentNode.parentNode.cells[12].getElementsByTagName("input")[0].value)==codPersonal)
                {
                    permiso=true;
                }
                while((!permiso)&&celda.parentNode.parentNode.parentNode.rows[contIndex]!=null&&celda.parentNode.parentNode.parentNode.rows[contIndex].cells.length==2)
                {
                    if(parseInt(celda.parentNode.parentNode.parentNode.rows[contIndex].cells[0].getElementsByTagName("input")[0].value)==codPersonal)
                    {
                        permiso=true;
                    }
                    contIndex++;
                }
                if(!permiso)alert('No se encuentra registrada como personal para modificar la version');
                return permiso;
            }
        </script>
        </head>
        <body>
            <h:form id="form1">
                <div align="center">
                    <h:outputText value="#{ManagedVersionesFormulaMaestra.cargarFormulasMaestrasNuevas}"   />
                    <%--a4j:jsFunction action="#{ManagedFormulaMaestra.tiposProduccion_change}" name="cargarF" reRender="dataFormula" /--%>
                    <h:outputText styleClass="outputTextTitulo"  value="Listado de Nuevas Formulas Maestras" />
                    <rich:dataTable value="#{ManagedVersionesFormulaMaestra.formulasMaestrasNuevasList}" var="data" id="dataNuevasFormulas"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';" 
                                    headerClass="headerClassACliente" binding="#{ManagedVersionesFormulaMaestra.formulasMaestrasNuevasDataTable}">
                        <f:facet name="header">
                            <rich:columnGroup>
                                <rich:column rowspan="2">
                                    <h:outputText value=""  />
                                </rich:column>
                                <rich:column rowspan="2">
                                   <h:outputText value="Personal Creacion"  />
                                </rich:column>
                                <rich:column colspan="4">
                                   <h:outputText value="Tipo Modificacion"  />
                                </rich:column>
                                <rich:column rowspan="2">
                                   <h:outputText value="Fecha Creacion"  />
                                </rich:column>
                                <rich:column rowspan="2">
                                   <h:outputText value="Producto"  />
                                </rich:column>
                                <rich:column rowspan="2">
                                   <h:outputText value="Lote"  />
                                </rich:column>
                                <rich:column rowspan="2">
                                   <h:outputText value="Estado Registro"  />
                                </rich:column>
                                <rich:column rowspan="2">
                                   <h:outputText value="Estado Version"  />
                                </rich:column>
                                <rich:column rowspan="2">
                                   <h:outputText value="Tipo Produccion"  />
                                </rich:column>
                                <rich:column rowspan="2">
                                   <h:outputText value="Personal Modificación"  />
                                </rich:column>
                                <rich:column rowspan="2">
                                    <h:outputText value="Estado<br>Personal" escape="false"  />
                                </rich:column>
                                
                                <rich:column rowspan="2" rendered="#{ManagedVersionesFormulaMaestra.codAreaEmpresaPersonal eq '41' || ManagedVersionesFormulaMaestra.codAreaEmpresaPersonal eq '77'}">
                                    <h:outputText value="MP"  />
                                </rich:column>
                                <rich:column rowspan="2" rendered="#{ManagedVersionesFormulaMaestra.codAreaEmpresaPersonal eq '41' || ManagedVersionesFormulaMaestra.codAreaEmpresaPersonal eq '77'}">
                                        <h:outputText value="EP"  />
                                </rich:column>
                                <rich:column rowspan="2" rendered="#{ManagedVersionesFormulaMaestra.codAreaEmpresaPersonal eq '85' || ManagedVersionesFormulaMaestra.codAreaEmpresaPersonal eq '93' }">
                                    <h:outputText value="ES"  />
                                </rich:column>
                                <rich:column rowspan="2" rendered="#{ManagedVersionesFormulaMaestra.codAreaEmpresaPersonal eq '40'}">
                                    <h:outputText value="MR"  />
                                </rich:column>
                                <rich:column  breakBefore="true">
                                    <h:outputText value="NF"  />
                                </rich:column>
                                <rich:column >
                                    <h:outputText value="MP y EP"  />
                                </rich:column>
                                <rich:column >
                                    <h:outputText value="ES"  />
                                </rich:column>
                                <rich:column >
                                    <h:outputText value="R"  />
                                </rich:column>
                            </rich:columnGroup>
                        </f:facet>
                        <rich:subTable var="subData" value="#{data.formulaMaestraVersionModificacionList}" rowKeyVar="rowkey">
                            <rich:column   rowspan="#{data.formulaMaestraVersionModificacionLength}"  rendered="#{rowkey eq 0}" >
                                <h:selectBooleanCheckbox value="#{data.checked}"  />
                            </rich:column>
                            <rich:column   rowspan="#{data.formulaMaestraVersionModificacionLength}"  rendered="#{rowkey eq 0}" >
                                <h:outputText value="#{data.personalCreacion.nombrePersonal}"  title="Personal Creacion" />
                            </rich:column>
                            <rich:column  rowspan="#{data.formulaMaestraVersionModificacionLength}"  rendered="#{rowkey eq 0}">
                                    <h:outputText value="X" rendered="#{data.modificacionNF}" />
                                </rich:column>
                            <rich:column  rowspan="#{data.formulaMaestraVersionModificacionLength}"  rendered="#{rowkey eq 0}">
                                    <h:outputText value="X" rendered="#{data.modificacionMPEP}" />
                                </rich:column>
                                <rich:column  rowspan="#{data.formulaMaestraVersionModificacionLength}"  rendered="#{rowkey eq 0}">
                                    <h:outputText value="X" rendered="#{data.modificacionES}" />
                                </rich:column>
                                <rich:column  rowspan="#{data.formulaMaestraVersionModificacionLength}"  rendered="#{rowkey eq 0}">
                                    <h:outputText value="X" rendered="#{data.modificacionR}" />
                                </rich:column>
                            <rich:column   rowspan="#{data.formulaMaestraVersionModificacionLength}"  rendered="#{rowkey eq 0}" >
                                <h:outputText value="#{data.fechaModificacion}" >
                                    <f:convertDateTime pattern="dd/MM/yyyy HH:mm"/>
                                </h:outputText>
                            </rich:column>
                             <rich:column   rowspan="#{data.formulaMaestraVersionModificacionLength}"  rendered="#{rowkey eq 0}" >
                                <h:outputText value="#{data.componentesProd.nombreProdSemiterminado}"  title="Producto" />
                            </rich:column>
                            <rich:column   rowspan="#{data.formulaMaestraVersionModificacionLength}"  rendered="#{rowkey eq 0}" >
                                <h:outputText value="#{data.cantidadLote}" title="Cantidad del Lote" />
                            </rich:column>
                            <rich:column   rowspan="#{data.formulaMaestraVersionModificacionLength}"  rendered="#{rowkey eq 0}" >
                                <h:outputText value="#{data.estadoRegistro.nombreEstadoRegistro}" />
                            </rich:column>
                            <rich:column   rowspan="#{data.formulaMaestraVersionModificacionLength}"  rendered="#{rowkey eq 0}" >
                                <h:outputText value="#{data.estadoVersionFormulaMaestra.nombreEstadoVersionFormulaMaestra}" />
                            </rich:column>
                            <rich:column   rowspan="#{data.formulaMaestraVersionModificacionLength}"  rendered="#{rowkey eq 0}" >
                                <h:outputText value="#{data.componentesProd.tipoProduccion.nombreTipoProduccion}" />
                            </rich:column>
                            <rich:column styleClass="celdaVersion">
                                        <h:outputText value="#{subData.personal.nombrePersonal}"/>
                                        <h:inputHidden value="#{subData.personal.codPersonal}"/>
                           </rich:column >
                           <rich:column styleClass="celdaVersion">
                                 <h:outputText value="#{subData.estadosVersionFormulaMaestra.nombreEstadoVersionFormulaMaestra}"/>
                           </rich:column >
                            <rich:column   rowspan="#{data.formulaMaestraVersionModificacionLength}"  rendered="#{(rowkey eq 0)&&(ManagedVersionesFormulaMaestra.codAreaEmpresaPersonal eq '41' || ManagedVersionesFormulaMaestra.codAreaEmpresaPersonal eq '77')}" >
                                <a4j:commandLink onclick="if(!verificarTransaccionUsuario(#{ManagedAccesoSistema.usuarioModuloBean.codUsuarioGlobal},this)){return false;}"
                                action="#{ManagedVersionesFormulaMaestra.seleccionarFormulaMaestraNuevaVersion}"
                                oncomplete="var a=Math.random();window.location.href='formulaMaestraDetalleMP/navegadorFormulaMaestraVersionMP.jsf?a='+a;">
                                    <h:graphicImage url="../img/organigrama3.jpg" />
                                </a4j:commandLink>
                            </rich:column>
                            <rich:column   rowspan="#{data.formulaMaestraVersionModificacionLength}"  rendered="#{(rowkey eq 0)&&(ManagedVersionesFormulaMaestra.codAreaEmpresaPersonal eq '41' || ManagedVersionesFormulaMaestra.codAreaEmpresaPersonal eq '77')}" >
                                <a4j:commandLink onclick="if(!verificarTransaccionUsuario(#{ManagedAccesoSistema.usuarioModuloBean.codUsuarioGlobal},this)){return false;}"
                                action="#{ManagedVersionesFormulaMaestra.seleccionarFormulaMaestraNuevaVersion}"
                                oncomplete="var a=Math.random();window.location.href='formulaMaestraDetalleEP/navegadorFormulaMaestraEP.jsf?a='+a;">
                                    <h:graphicImage url="../img/organigrama3.jpg" />
                                </a4j:commandLink>
                            </rich:column>
                            <rich:column   rowspan="#{data.formulaMaestraVersionModificacionLength}"  rendered="#{(rowkey eq 0)&&(ManagedVersionesFormulaMaestra.codAreaEmpresaPersonal eq '85' || ManagedVersionesFormulaMaestra.codAreaEmpresaPersonal eq '93')}" >
                                <a4j:commandLink onclick="if(!verificarTransaccionUsuario(#{ManagedAccesoSistema.usuarioModuloBean.codUsuarioGlobal},this)){return false;}"
                                action="#{ManagedVersionesFormulaMaestra.seleccionarFormulaMaestraNuevaVersion}"
                                oncomplete="var a=Math.random();window.location.href='formulaMaestraDetalleES/navegadorFormulaMaestraEs.jsf?a='+a;">
                                    <h:graphicImage url="../img/organigrama3.jpg" />
                                </a4j:commandLink>
                            </rich:column>
                        </rich:subTable>
                        
                    </rich:dataTable>
                    
                    <div align="center" style="margin-top:0.8em">
                        <a4j:commandButton styleClass="btn" value="Agregar" oncomplete="var a=Math.random();window.location.href='agregarNuevaFormulaMaestra.jsf?agre='+a" rendered="#{ManagedVersionesFormulaMaestra.codAreaEmpresaPersonal eq '41'}"/>
                        <a4j:commandButton styleClass="btn" value="Editar" action="#{ManagedVersionesFormulaMaestra.editarNuevaFormulaMaestraVersion_action}" onclick="if(!editarItem('form1:dataNuevasFormulas')){return false;}"
                        oncomplete="var a=Math.random();window.location.href='editarNuevaFormulaMaestra.jsf?a='+a;" rendered="#{ManagedVersionesFormulaMaestra.codAreaEmpresaPersonal eq '41'}"/>
                        <a4j:commandButton styleClass="btn" value="Enviar a Aprovacion" onclick="if(!editarItem('form1:dataNuevasFormulas')){return false;}" reRender="dataNuevasFormulas"
                        action="#{ManagedVersionesFormulaMaestra.enviarNuevaFormulaAAprovacion_action}" oncomplete="if(#{ManagedVersionesFormulaMaestra.mensaje eq '1'}){alert('La formula maestra se envio a aprovacion');}
                        else{alert('#{ManagedVersionesFormulaMaestra.mensaje}');}"/>
                        <a4j:commandButton value="Añadirme a Version" onclick="if(!editarItem('form1:dataNuevasFormulas')){return false;}"
                        action="#{ManagedVersionesFormulaMaestra.adjuntarPersonalNuevaFormula}" styleClass="btn" oncomplete="if(#{ManagedVersionesFormulaMaestra.mensaje eq '1'}){alert('Se registro como personal para modificar');}else{alert('#{ManagedVersionesFormulaMaestra.mensaje}');}"
                        reRender="dataNuevasFormulas"/>
                    </div>
                <!--cerrando la conexion-->
                
                
            </h:form>
            <a4j:status id="statusPeticion"
                                onstart="Richfaces.showModalPanel('ajaxLoadingModalBox',{width:100, top:100})"
                                onstop="Richfaces.hideModalPanel('ajaxLoadingModalBox')">
                    </a4j:status>

                    <rich:modalPanel id="ajaxLoadingModalBox" minHeight="100"
                                     minWidth="200" height="80" width="400" zindex="100" onshow="window.focus();">

                        <div align="center">
                            <h:graphicImage value="../img/load2.gif" />
                        </div>
                    </rich:modalPanel>
        </body>
    </html>
    
</f:view>

