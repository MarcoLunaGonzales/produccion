<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>
    
    <html>
        <head>
            <title></title>
            <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" /> 
            <script type="text/javascript" src="../js/general.js" ></script>
            <script type="text/javascript">
                function mostrarReporte(contenidoReporte)
                {
                   var div=document.getElementById('formSuper');
                   div.style.height=document.body.offsetHeight;
                   div.style.width=document.body.offsetWidth;
                   div.style.visibility='visible';
                   alert(contenidoReporte);
                   

                }
                function ocultarReporte()
                {
                    document.getElementById('formSuper').style.visibility='hidden';
                }
                function onScroll(nameTable,nameContainer)
                {
                    var div=document.getElementById(nameContainer);
                    var tabla=document.getElementById(nameTable);
                   
                    //tabla.thead.style.marginTop=tabla.rows[0].offsetHeight+'px';
                    tabla.rows[0].style.position='absolute';
                    tabla.rows[0].style.marginTop=(div.scrollTop-tabla.rows[0].offsetHeight-2)+'px';
                    tabla.rows[0].style.visibility='hidden';
                    tabla.rows[0].style.visibility='visible';
                    tabla.rows[0].style.marginLeft='-2px';
                    
                }
                onerror=mensaje;
                  function mensaje()
                    {
                    alert('ocurrio un error');
                    }
            A4J.AJAX.onError = function(req,status,message){
            window.alert("Ocurrio un error "+message+" continue con su transaccion ");
            }
            A4J.AJAX.onExpired = function(loc,expiredMsg){
            if(window.confirm("Ocurrio un error al momento realizar la transaccion: "+expiredMsg+" location: "+loc)){
            return loc;
            } else {
            return false;
            }
            }
            function openPopup(celda){
                //alert(celda.parentNode.parentNode.innerHTML);
                var url="reporteDetalleMaterialesReactivos.jsf?al="+Math.random()+'&codFormula='+document.getElementById("form1:codFormulaMaestra").value+
                    "&codTipoMaterial="+celda.parentNode.parentNode.cells[2].getElementsByTagName('select')[0].value+
                    "&cantidadDisolucion="+celda.parentNode.parentNode.cells[3].getElementsByTagName('input')[0].value+
                    "&cantidadValoracion="+celda.parentNode.parentNode.cells[4].getElementsByTagName('input')[0].value;
                    window.open(url,'detalle','top=50,left=200,width=800,height=500,scrollbars=1,resizable=1');
                   
                   return null;
                }
            function valEnteros()
            {
              if ((event.keyCode < 48 || event.keyCode > 57) )
                 {
                    alert('Solo puede registrar numeros enteros');
                    event.returnValue = false;
                 }
            }
            function valBuscador()
            {
                if(document.getElementById("form11:codProgramprod").value==0 && document.getElementById("form11:loteProduccion").value=='')
                    {
                        alert("Para buscar en todos los programas de produccion debe introducir un indicio del lote");
                        return false;
                    }
                    return true;
            }
            function validarRegistro()
            {
                    var tabla=document.getElementById("form1:dataAnalisis");
                    document.getElementById("form1:cantidadMuestras").className='inputText';
                    if(document.getElementById("form1:cantidadMuestras").value<=0)
                    {
                        document.getElementById("form1:cantidadMuestras").className='inputText registrar';
                        alert('Debe registrar la cantidad de muestras');
                        return false;
                    }
                    if(tabla.rows.length==1)
                    {
                        alert('Debe generar los analisis');
                        return false;
                    }
                    tabla.rows[1].cells[1].getElementsByTagName('input')[0].className='inputText';

                    if(tabla.rows[1].cells[1].getElementsByTagName('input')[0].value=='')
                    {
                        tabla.rows[1].cells[1].getElementsByTagName('input')[0].className='inputText registrar';
                        alert('Debe registrar la primera fecha de Analisis');
                        return false;
                    }


                            return true;

            }

            </script>
            <style>
                .registrar{
                    border:2px solid red;
                }
            </style>
        </head>
        <body >
            <h:form id="form1"  >
                
               
                    <center>
                        <h:outputText value="#{ManagedProgramaProduccionControlCalidad.cargarEditarProgramaControlCalidad}"/>
                                     <rich:panel headerClass="headerClassACliente" style="width:50%;align:center">
                                        <f:facet name="header">
                                                <h:outputText value="Datos Programa De Estabilidad"/>
                                        </f:facet>
                                        <h:panelGrid columns="3">
                                            <h:outputText value="Nombre Programa" styleClass="outputText2" style="font-weight:bold"/>
                                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                            <h:outputText value="#{ManagedProgramaProduccionControlCalidad.programaProduccionPeriodoSeleccionado.nombreProgramaProduccion}"
                                            styleClass="outputText2" style=""/>
                                            <h:outputText value="Observacion Programa" styleClass="outputText2" style="font-weight:bold"/>
                                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                            <h:outputText value="#{ManagedProgramaProduccionControlCalidad.programaProduccionPeriodoSeleccionado.obsProgramaProduccion}"
                                            styleClass="outputText2" style=""/>
                                        </h:panelGrid>
                                </rich:panel>
                <rich:panel  headerClass="headerClassACliente"   style="width:70%;margin-top:12px">
                    <f:facet name="header">
                        <h:outputText value="Datos Analisis de Estabilidad"/>
                    </f:facet>
                        <rich:panel headerClass="headerClassACliente" id="panelCabecera" style="width:70%;margin-top:12px">
                            <f:facet name="header">
                                <h:outputText value="Datos del Lote de Programa Produccion"/>
                            </f:facet>
                            <h:panelGrid columns="6">
                                <h:outputText value="Producto" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="::" styleClass="outputText2"style="font-weight:bold"/>
                                <h:outputText value="#{ManagedProgramaProduccionControlCalidad.programaProduccionControlCalidadEditar.componentesProd.nombreProdSemiterminado}" styleClass="outputText2"/>
                                <h:outputText value="Lote" styleClass="outputText2" style="font-weight:bold;"/>
                                <h:outputText value="::" styleClass="outputText2"style="font-weight:bold"/>
                                <h:outputText value="#{ManagedProgramaProduccionControlCalidad.programaProduccionControlCalidadEditar.codLoteProduccion}" styleClass="outputText2"/>
                                <h:outputText value="Tipo Programa Produccion" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="::" styleClass="outputText2"style="font-weight:bold"/>
                                <h:outputText value="#{ManagedProgramaProduccionControlCalidad.programaProduccionControlCalidadEditar.tiposProgramaProduccion.nombreTipoProgramaProd}" styleClass="outputText2"/>
                                
                                <h:outputText value="Cantidad Lote" styleClass="outputText2"  style="font-weight:bold;"/>
                                <h:outputText value="::" styleClass="outputText2"style="font-weight:bold"/>
                                <h:outputText value="#{ManagedProgramaProduccionControlCalidad.programaProduccionControlCalidadEditar.cantLoteProduccion}" styleClass="outputText2"/>
                                <h:outputText value="Programa Produccion" styleClass="outputText2"  style="font-weight:bold;"/>
                                <h:outputText value="::" styleClass="outputText2"style="font-weight:bold"/>
                                <h:outputText value="#{ManagedProgramaProduccionControlCalidad.programaProduccionControlCalidadEditar.programaProduccionPeriodoLoteProduccion.nombreProgramaProduccion}" styleClass="outputText2"/>
                           </h:panelGrid>
                           <h:inputHidden value="#{ManagedProgramaProduccionControlCalidad.programaProduccionControlCalidadEditar.formulaMaestra.codFormulaMaestra}" id="codFormulaMaestra"/>
                            
                            <a4j:commandButton  value="Seleccionar Programa Produccion" timeout="10000"
                            styleClass="btn" onclick="Richfaces.showModalPanel('panelSeleccionarProgramaProduccion');" reRender="contenidoSeleccionarProgramaProduccion"/>
                        </rich:panel>

                        <h:panelGrid columns="6">
                                <h:outputText value="Cantidad Muestras" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="::" styleClass="outputText2"style="font-weight:bold"/>
                                <h:inputText id="cantidadMuestras" onkeypress="valEnteros();" value="#{ManagedProgramaProduccionControlCalidad.programaProduccionControlCalidadEditar.cantidadMuestras}" styleClass="outputText2"/>
                                <h:outputText value="Almacen Muestra" styleClass="outputText2" style="font-weight:bold;margin-left:16px"/>
                                <h:outputText value="::" styleClass="outputText2"style="font-weight:bold"/>
                                 <h:selectOneMenu value="#{ManagedProgramaProduccionControlCalidad.programaProduccionControlCalidadEditar.almacenesMuestra.codAlmacenMuestra}" styleClass="inputText" id="dataAlamacen" >
                                                <f:selectItems value="#{ManagedProgramaProduccionControlCalidad.almacenMuestraSelectList}"/>
                                 </h:selectOneMenu>
                                <h:outputText value="Tipo de Estudio Estabilidad" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="::" styleClass="outputText2"style="font-weight:bold"/>
                                <h:selectOneMenu value="#{ManagedProgramaProduccionControlCalidad.programaProduccionControlCalidadEditar.tiposEstudioEstabilidad.codTipoEstudioEstabilidad}" styleClass="inputText"  >
                                    <%--f:selectItem itemValue='0' itemLabel="--Ninguno--"/--%>
                                    <f:selectItems value="#{ManagedProgramaProduccionControlCalidad.tiposEstudioEstabilidadSelectList}"/>
                                    <a4j:support action="#{ManagedProgramaProduccionControlCalidad.tipoEstudioEstabilidadEditar_change}" event="onchange" reRender="tiempoEstudio,dataAnalisis"/>
                                 </h:selectOneMenu>

                                <h:outputText value="Tiempo Estudio" styleClass="outputText2"  style="font-weight:bold;margin-left:16px"/>
                                <h:outputText value="::" styleClass="outputText2"style="font-weight:bold"/>
                                <h:outputText id="tiempoEstudio" value="#{ManagedProgramaProduccionControlCalidad.programaProduccionControlCalidadEditar.tiempoEstudio}" styleClass="outputText2"/>
                                <h:outputText value="Fecha Inicio Analisis" styleClass="outputText2"  style="font-weight:bold;margin-left:16px"/>
                                    <h:outputText value="::" styleClass="outputText2"style="font-weight:bold"/>
                                <h:panelGroup>
                                <h:inputText value="#{ManagedProgramaProduccionControlCalidad.fechaInicioAnalisis}" styleClass="inputText" onblur="valFecha(this)"  id="fechaPrimarRegistro" size="10">
                                    <f:convertDateTime pattern="dd/MM/yyyy"/>
                                </h:inputText>
                                <h:graphicImage url="../img/fecha.bmp"  id="imagenFecha1" />
                                <h:outputText value="<DLCALENDAR tool_tip=\"Seleccione la Fecha\"  daybar_style=\"background-color: DBE1E7;font-family: verdana; color:000000;\"    navbar_style=\"background-color: 7992B7; color:ffffff;\"  input_element_id=\"form1:fechaPrimarRegistro\" click_element_id=\"form1:imagenFecha1\"></DLCALENDAR>"  escape="false"  />
                                </h:panelGroup>
                           </h:panelGrid>
                           <a4j:commandButton value="Generar Analisis" action="#{ManagedProgramaProduccionControlCalidad.generarCronogramaAnalisisEditar_action}"  id="buttonReplace" styleClass="btn" reRender="dataAnalisis"/>

                 </rich:panel>
                 
                 <rich:dataTable value="#{ManagedProgramaProduccionControlCalidad.programaProduccionControlCalidadEditar.programaProduccionControlCalidadAnalisisList}" var="data" id="dataAnalisis"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente" style="margin-top:12px"
                                    binding= "#{ManagedProgramaProduccionControlCalidad.programaProduccionControlCalidadAnalisisEditarDataTable}" >
                                        <rich:column >
                                            <f:facet name="header">
                                                <h:outputText value="Tiempo Estudio" style="font-weight:bold"/>
                                            </f:facet>
                                            <h:inputText onkeypress="valEnteros();" value="#{data.tiempoEstudio}" styleClass="inputText" size="4"/>

                                        </rich:column >
                                         <rich:column  >
                                            <f:facet name="header">
                                                <h:outputText value="Fecha Analisis"style="font-weight:bold"/>
                                            </f:facet>
                                            <h:inputText value="#{data.fechaAnalisis}" styleClass="inputText" onblur="valFecha(this)" size="10">
                                                <f:convertDateTime pattern="dd/MM/yyyy"/>
                                            </h:inputText>
                                        </rich:column >
                                        <%--rich:column  rendered="false" >
                                            <f:facet name="header">
                                                <h:outputText value="Tipo Material Reactivo"style="font-weight:bold"/>
                                            </f:facet>
                                            <h:selectOneMenu value="#{data.tipoMaterialReactivo.codTipoMaterialReactivo}" styleClass="inputText" id="datas" >
                                                <f:selectItems value="#{ManagedProgramaProduccionControlCalidad.tiposMaterialReactivoList}"/>
                                            </h:selectOneMenu>
                                        </rich:column >
                                        <rich:column rendered="false"  >
                                            <f:facet name="header">
                                                <h:outputText  value="Cantidad Test de Disolucion"style="font-weight:bold"/>
                                            </f:facet>
                                           <center> <h:inputText onkeypress="valEnteros();" value="#{data.cantidadTestDisolucion}" size="4" styleClass="inputText"/></center>
                                        </rich:column >
                                        <rich:column rendered="false" >
                                            <f:facet name="header">
                                                <h:outputText value="Cantidad Test de Valoración"style="font-weight:bold"/>
                                            </f:facet>
                                            <center><h:inputText  onkeypress="valEnteros();"value="#{data.cantidadTestValoracion}" size="4" styleClass="inputText"/></center>
                                        </rich:column --%>
                                         
                                         <rich:column  >
                                            <f:facet name="header">
                                                <h:outputText value="Observación" style="font-weight:bold"/>
                                            </f:facet>
                                            <h:inputText value="#{data.observacion}" styleClass="inputText" />

                                        </rich:column >
                                         <%--rich:column  >
                                            <f:facet name="header">
                                                <h:outputText value="Ver Detalles" style="font-weight:bold"/>
                                            </f:facet>
                                            <a href="#" onclick="openPopup(this)">
                                                <img src="../img/organigrama3.jpg">
                                            </a>
                                            
                                        </rich:column --%>
                                        <rich:column  >
                                            <f:facet name="header">
                                                <h:outputText value="Editar Materiales" style="font-weight:bold"/>
                                            </f:facet>
                                            <a4j:commandLink  action="#{ManagedProgramaProduccionControlCalidad.cargarMaterialesEditar_action}" reRender="contenidoMateriales" oncomplete="Richfaces.showModalPanel('panelMateriales')" >
                                                <h:graphicImage url="../img/organigrama3.jpg"  />
                                            </a4j:commandLink>
                                        </rich:column >
                                          
                        </rich:dataTable>
                        <div style="margin-top:6px;">
                            <a4j:commandButton onclick="if(validarRegistro()==false){return false;}" timeout="10000" value="Guardar" styleClass="btn"  action="#{ManagedProgramaProduccionControlCalidad.guardarEdicionProgramaProduccionControlCalidad_action}"
                    oncomplete="if(#{ManagedProgramaProduccionControlCalidad.mensaje eq '1'}){alert('Se guardo la edición del Programa Produccion de Control de Calidad');window.location='navegador_programa_produccion_control_calidad.jsf';}else{alert('#{ManagedProgramaProduccionControlCalidad.mensaje}')}" />
                    <a4j:commandButton timeout="10000" value="Cancelar" styleClass="btn" onclick="window.location='navegador_programa_produccion_control_calidad.jsf'"/>
                    </div>
                
                </center>
                
            </h:form>
            <rich:modalPanel id="panelSeleccionarProgramaProduccion"  minHeight="350"  minWidth="800"
                                     height="350" width="800"
                                     zindex="200"
                                     headerClass="headerClassACliente "
                                     resizeable="true" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Seleccionar Programa Producción"/>
                        </f:facet>
                        <a4j:form id="form11">
                                 <h:panelGroup id="contenidoSeleccionarProgramaProduccion">
                                     <rich:panel headerClass="headerClassACliente" style="widht:80%" >
                                        <f:facet name="header">
                                            <h:outputText value="Programa Producción"/>
                                        </f:facet>
                                        <center>
                                           
                                        <h:panelGrid columns="7">
                                            <h:outputText value="Programa Produccion Periodo" styleClass="outputText2" style="font-weight:bold"/>
                                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                            <h:selectOneMenu value="#{ManagedProgramaProduccionControlCalidad.programaProduccionBuscar.codProgramaProduccion}" styleClass="inputText" id="codProgramprod" >
                                                <f:selectItem itemValue="0" itemLabel="-TODOS-"/>
                                                <f:selectItems value="#{ManagedProgramaProduccionControlCalidad.programaProdPeriodosList}"/>
                                                <a4j:support action="#{ManagedProgramaProduccionControlCalidad.tipoEstudioEstabilidad_change}" event="onchange" reRender="dataAnalisis" />
                                             </h:selectOneMenu>
                                             <h:outputText value="Lote Programa Produccion" styleClass="outputText2" style="font-weight:bold"/>
                                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                            <h:inputText value="#{ManagedProgramaProduccionControlCalidad.programaProduccionBuscar.codLoteProduccion}" styleClass="inputText" id="loteProduccion"/>
                                            <a4j:commandButton onclick="if(valBuscador()==false){return false;}" timeout="10000" value="Buscar" action="#{ManagedProgramaProduccionControlCalidad.buscarProgramaProduccionAgregarAction}"
                                            reRender="dataProgProd" styleClass="btn"/>
                                        </h:panelGrid>
                                        
                                        </center>
                                    </rich:panel>
                                     <center>
                                    <div style="height:200px;overflow:auto; margin-top:6px;"  id="container" ><%--onscroll="onScroll('form11:dataProgProd','container')"--%>
                                        <rich:dataTable value="#{ManagedProgramaProduccionControlCalidad.programaProdDataModel}"
                                        var="data" id="dataProgProd"
                                    
                                    headerClass="headerClassACliente"  >
                                                <rich:column  >
                                                    <f:facet name="header">
                                                        <h:outputText value="Programa Produccion"/>
                                                    </f:facet>
                                                    <h:outputText value="#{data.programaProduccionPeriodoLoteProduccion.nombreProgramaProduccion}" styleClass="outputText2"/>

                                                </rich:column >
                                                <rich:column  >
                                                    <f:facet name="header">
                                                        <h:outputText value="Nombre Producto"/>
                                                    </f:facet>
                                                    
                                                    <h:outputText value="#{data.componentesProd.nombreProdSemiterminado}" styleClass="outputText2"/>

                                                </rich:column >
                                                <rich:column  >
                                                    <f:facet name="header">
                                                        <h:outputText value="Lote"/>
                                                    </f:facet>
                                                    <a4j:commandLink timeout="10000" reRender="panelCabecera,buttonReplace" action="#{ManagedProgramaProduccionControlCalidad.seleccionarProgramaProduccionEditar_action}"
                                                    value="#{data.codLoteProduccion}" oncomplete="javascript:Richfaces.hideModalPanel('panelSeleccionarProgramaProduccion')"
                                                    style="color:blue" title="Seleccionar"/>
                                                    

                                                </rich:column >
                                                
                                                <rich:column  >
                                                    <f:facet name="header">
                                                        <h:outputText value="Tipo Programa"/>
                                                    </f:facet>
                                                    <h:outputText value="#{data.tiposProgramaProduccion.nombreTipoProgramaProd}" styleClass="outputText2"/>

                                                </rich:column >
                                                
                                                <rich:column  >
                                                    <f:facet name="header">
                                                        <h:outputText value="Cantidad Lote"/>
                                                    </f:facet>
                                                    <h:outputText value="#{data.cantLoteProduccion}" styleClass="outputText2"/>

                                                </rich:column >

                                        </rich:dataTable>
                                    </div>
                                  </h:panelGroup>
                                  <a4j:commandButton timeout="10000" value="Cancelar"  styleClass="btn" onclick="javascript:Richfaces.hideModalPanel('panelSeleccionarProgramaProduccion')" />
                                </center>
                        </a4j:form>
            </rich:modalPanel>


            <rich:modalPanel id="panelMaterialesReactivos"  minHeight="300"  minWidth="500"
                                     height="300" width="500"
                                     zindex="200"
                                     headerClass="headerClassACliente "
                                     resizeable="true" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Detalles de Materiales Reactivos"/>
                        </f:facet>
                        <a4j:form id="form5">
                                 <h:panelGroup id="contenidoMaterialesReactivos">
                                     <center>
                                    <div style="height:200px;overflow:auto; margin-top:6px;"><%--onscroll="onScroll('form11:dataProgProd','container')"--%>
                                    <rich:dataTable value="#{ManagedProgramaProduccionControlCalidad.materialesDataModel}"
                                        var="data" id="dataMaterialesReactivos"

                                    headerClass="headerClassACliente"  >

                                                <rich:column  >
                                                    <f:facet name="header">
                                                        <h:outputText value="Tipo Analisis"/>
                                                    </f:facet>

                                                    <h:outputText value="#{data.tiposAnalisisMaterialReactivo.nombreTiposAnalisisMaterialReactivo}" styleClass="outputText2"/>

                                                </rich:column >
                                                
                                                <rich:column  >
                                                    <f:facet name="header">
                                                        <h:outputText value="Material"/>
                                                    </f:facet>
                                                    <h:outputText value="#{data.material.nombreMaterial}" styleClass="outputText2"/>

                                                </rich:column >
                                                <rich:column  >
                                                    <f:facet name="header">
                                                        <h:outputText value="Cantidad"/>
                                                    </f:facet>
                                                    <h:outputText value="#{data.cantidad}" styleClass="outputText2">
                                                        <f:convertNumber locale="en" pattern="###0.0"/>
                                                    </h:outputText>

                                                </rich:column >
                                                <rich:column  >
                                                    <f:facet name="header">
                                                        <h:outputText value="Unidad Medida"/>
                                                    </f:facet>
                                                    <h:outputText value="#{data.unidadMedida.nombreUnidadMedida}" styleClass="outputText2"/>

                                                </rich:column >
                                           </rich:dataTable>
                                    </div>
                                  </h:panelGroup>
                                  <a4j:commandButton timeout="10000" value="Cancelar"  styleClass="btn" onclick="javascript:Richfaces.hideModalPanel('panelMaterialesReactivos')" />
                                </center>
                        </a4j:form>
            </rich:modalPanel>

<rich:modalPanel id="panelMateriales"  minHeight="300"  minWidth="400"
                                     height="300" width="400"
                                     zindex="200"
                                     headerClass="headerClassACliente "
                                     resizeable="true" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Registrar Materiales"/>
                        </f:facet>
                        <a4j:form id="form1X">
                                 <h:panelGroup id="contenidoMateriales">

                                     <center>
                                    <div style="height:200px;overflow:auto; margin-top:6px;"  id="container" ><%--onscroll="onScroll('form11:dataProgProd','container')"--%>
                                              <rich:dataTable value="#{ManagedProgramaProduccionControlCalidad.materialesList}"
                                                              var="data" id="dataProgProd" headerClass="headerClassACliente"  >

                                                <rich:column  >
                                                    <f:facet name="header">
                                                        <h:outputText value=""/>
                                                    </f:facet>
                                                    <h:selectBooleanCheckbox value="#{data.checked}" />

                                                </rich:column >
                                                <rich:column  >
                                                    <f:facet name="header">
                                                        <h:outputText value="Material"/>
                                                    </f:facet>
                                                    <h:outputText value="#{data.materiales.nombreMaterial}" styleClass="outputText2"/>

                                                </rich:column >
                                                <rich:column  >
                                                    <f:facet name="header">
                                                        <h:outputText value="Unid."/>
                                                    </f:facet>
                                                    <h:outputText value="#{data.materiales.unidadesMedida.abreviatura}" styleClass="outputText2"/>

                                                </rich:column >

                                                <rich:column  >
                                                    <f:facet name="header">
                                                        <h:outputText value="Cant."/>
                                                    </f:facet>
                                                    <h:inputText value="#{data.cantidad}" styleClass="outputText2" size = "8" />
                                                </rich:column >

                                        </rich:dataTable>
                                    </div>
                                  </h:panelGroup>
                                  <a4j:commandButton timeout="10000" value="Guardar"  styleClass="btn" onclick="javascript:Richfaces.hideModalPanel('panelMateriales')" />
                                  <a4j:commandButton timeout="10000" value="Cancelar"  styleClass="btn" onclick="javascript:Richfaces.hideModalPanel('panelMateriales')" />

                                </center>
                        </a4j:form>
            </rich:modalPanel>





           <a4j:status id="statusPeticion"
                        onstart="Richfaces.showModalPanel('ajaxLoadingModalBox',{width:100, top:100})"
                        onstop="Richfaces.hideModalPanel('ajaxLoadingModalBox')">
            </a4j:status>

            <rich:modalPanel id="ajaxLoadingModalBox" minHeight="100"
                             minWidth="200" height="80" width="400" zindex="400" onshow="window.focus();">

                <div align="center">
                    <h:graphicImage value="../img/load2.gif" />
                </div>
            </rich:modalPanel>
            

        </body>
        <script type="text/javascript" language="JavaScript"  src="../js/dlcalendar.js" ></script>
        
    </html>
    
</f:view>

