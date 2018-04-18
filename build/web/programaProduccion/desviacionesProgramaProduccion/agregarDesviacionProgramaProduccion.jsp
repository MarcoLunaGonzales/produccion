<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>

    
    <html>
        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../../css/chosen.css" /> 
            <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" /> 
            <script type="text/javascript" src="../../js/general.js" ></script> 
            <script type="text/javascript">
                
            function validarAgregarFormulaMaestraDetalleMp()
            {
                return (validarSeleccionMayorACeroById("agregarMP:formAgregar:codMaterialFmMpAgregar")
                            &&validarMayorACeroById("agregarMP:formAgregar:cantidadUnitariAgregar")
                            &&validarMayorACeroById("agregarMP:formAgregar:valorConversionDensidad")
                            &&validarMayorACeroById("agregarMP:formAgregar:cantidadMaximaFraccion"));
            }
            function validarEditarFormulaMaestraDetalleMp()
            {
                return (validarMayorACeroById("editarMP:formEditarDesviacionFormulaMaestraDetalleMp:cantidadUnitariAgregar")
                        &&validarMayorACeroById("editarMP:formEditarDesviacionFormulaMaestraDetalleMp:cantidadMaximaFraccion"));
            }
            function validarAgregarFormulaMaestraDetalleEp()
            {
                return (validarMayorACeroById("agregarEp:formAgregarEp:cantidadUnitariaEp"));
            }
            function validarAgregarFormulaMaestraDetalleEs()
            {
                return (validarMayorACeroById("agregarEs:formAgregarEs:cantidadMaterial"));
            }
            function validarEditarFormulaMaestraDetalleEs()
            {
                return (validarMayorACeroById("editarEs:formEditarEs:cantidadMaterial"));
            }
            function validarEditarFormulaMaestraDetalleEp()
            {
                return (validarMayorACeroById("editarEp:formEditarEp:cantidadUnitariaEp"));
            }
            function validarCantidadesFraccion()
            {
               var cantidadTotal=parseFloat(document.getElementById('editarFraccion:formEditarFracciones:cantidadTotal').innerHTML);
               var registros=document.getElementById("editarFraccion:formEditarFracciones:dataMPfraccion").getElementsByTagName("tbody")[0];
               var sumaTotal=0;
               for(var i=0;i<registros.rows.length;i++)
               {
                   if(!validarMayorACero(registros.rows[i].cells[1].getElementsByTagName("input")[0]))
                   {
                       return false;
                   }
                   sumaTotal+=parseFloat(registros.rows[i].cells[1].getElementsByTagName("input")[0].value);
               }
               sumaTotal = (Math.round(sumaTotal*100)/100);
               if(cantidadTotal!=sumaTotal)
               {
                   alert("La suma de las cantidades es diferente a la CANTIDAD TOTAL.");
                   return false;
               }
               return true;
            }
            
            
             function validarGuardarDesviacion()
             {
                 return validarRegistroNoVacio(document.getElementById('form1:descripcionDesviacion'));
             }
             
            
            function recalcularTablasEp()
            {
                var tabla=document.getElementById("form1:dataMaterialesEP").getElementsByTagName("tbody")[0];
                for(var i=0;i<tabla.rows.length;i++)
                {
                    if(tabla.rows[i].cells.length>2)
                    {
                        var input=tabla.rows[i].cells[2].getElementsByTagName("input")[0];
                        if(input!=null)
                        {
                            input.onkeyup();
                        }
                    }
                }
            }
            function recalcularTablas()
            {
                for(var i=0;i<3;i++)
                {
                    var tabla=document.getElementById("form1:dataMaterialesMP"+i);
                    if(tabla!=null)
                    {
                        var body=tabla.getElementsByTagName("tbody")[0];
                        for(var j=0;j<body.rows.length;j++)
                        {
                            if(body.rows[j].cells.length>3)
                            {
                                console.log(body.rows[j].cells[2].innerHTML);
                                body.rows[j].cells[2].getElementsByTagName("input")[0].onkeyup();
                            }
                        }
                    }
                }
            }
            function calcularTotalLote(celda,numeroTab)
            {
                var volumen=(document.getElementById("form1:cantidadVolumen"+numeroTab)!==null?parseFloat(document.getElementById("form1:cantidadVolumen"+numeroTab).innerHTML):0);
                var volumenDosificado=(document.getElementById("form1:cantidadVolumenDeDosificado"+numeroTab)!==null?parseFloat(document.getElementById("form1:cantidadVolumenDeDosificado"+numeroTab).innerHTML):0);
                var cantidadDecimales=2;
                var incrementoVolumen=(volumen>0&&volumenDosificado>0?(volumenDosificado/volumen):1);
                var toleranciaFabricacion=parseFloat(document.getElementById("form1:toleranciaVolumenfabricar"+numeroTab).innerHTML);
                var tamanioLote=parseFloat(document.getElementById("form1:tamanioLoteProduccion"+numeroTab).innerHTML);
                var cantidadUnitariaGramos=parseFloat(celda.parentNode.parentNode.cells[2].getElementsByTagName("input")[0].value);
                var cantidadTotal=redondear(
                ((cantidadUnitariaGramos*incrementoVolumen*tamanioLote)+((cantidadUnitariaGramos*incrementoVolumen*tamanioLote)*(toleranciaFabricacion/100)))
                ,cantidadDecimales);
                celda.parentNode.parentNode.cells[3].getElementsByTagName("span")[0].innerHTML=cantidadTotal;
                
                var tabla=celda.parentNode.parentNode.parentNode;
                var cantidadCeldasPadre=celda.parentNode.parentNode.cells.length;
                var calcular=true;
                tabla.rows[(celda.parentNode.parentNode.rowIndex-2)].cells[cantidadCeldasPadre-2].getElementsByTagName("span")[0].innerHTML=
                                redondear(cantidadTotal*parseFloat(tabla.rows[(celda.parentNode.parentNode.rowIndex-2)].cells[cantidadCeldasPadre-2].getElementsByTagName("input")[0].value)/100,2);
                for(var i=(celda.parentNode.parentNode.rowIndex-1);i<tabla.rows.length&&calcular;i++)
                {
                    if(tabla.rows[i].cells.length<cantidadCeldasPadre)
                    {
                        tabla.rows[i].cells[0].getElementsByTagName("span")[0].innerHTML=
                                redondear(cantidadTotal*parseFloat(tabla.rows[i].cells[0].getElementsByTagName("input")[0].value)/100,2);
                        
                    }
                    else
                        calcular=false;
                }
            }
         </script>
         <style>
             .seleccionado
             {;
                 background-color:#98FB98;
             }
             .cambioPresentacion
             {
                 background-color:#dddddd;
                 color: black;
                 font-weight: bold;
                 text-align: center;
             }
             .footerClass
             {
                 background-color: white;
                 padding: 12px;
                 text-align:center ;
             }
         </style>
        </head>
        <body>
            <f:view>
            
            <a4j:form id="form1">
                <div align="center" >
                    
                    <h:outputText value="Generar Desviación Planificada de materiales" styleClass="outputTextTituloSistema"/>
                    <h:outputText value="#{ManagedProgramaProduccionDesviacion.cargarDesviacionFormulaMaestraMateriales}" />
                    <h:panelGroup id="contenidoAgregarLote">
                        
                        <rich:panel headerClass="headerClassACliente" style="width:80%" >
                            <f:facet name="header">
                                <h:outputText value="Datos Del Lote"/>
                            </f:facet>
                            <h:panelGrid columns="6">
                                <h:outputText styleClass="outputTextBold" value="Lote"/>
                                <h:outputText styleClass="outputTextBold" value="::"/>
                                <h:outputText value="#{ManagedProgramaProduccionDesviacion.desviacionProgramaProduccion.programaProduccion.codLoteProduccion}" styleClass="outputText2" id="cantidadLote"/>
                                <h:outputText styleClass="outputTextBold" value="Programa Producción"/>
                                <h:outputText styleClass="outputTextBold" value="::"/>
                                <h:outputText value="#{ManagedProgramaProduccionDesviacion.desviacionProgramaProduccion.programaProduccion.programaProduccionPeriodo.nombreProgramaProduccion}" styleClass="outputText2"/>
                            </h:panelGrid>
                            <rich:dataTable headerClass="headerClassACliente" value="#{ManagedProgramaProduccionDesviacion.programaProduccionDesviacionList}"
                                            var="data"  id="datosLoteProduccion">
                                <f:facet name="header">
                                    <rich:columnGroup>
                                        <rich:column>
                                            <h:outputText value="PRODUCTO"/>
                                        </rich:column>
                                        <rich:column>
                                            <h:outputText value="TIPO PRODUCCION"/>
                                        </rich:column>
                                        <rich:column>
                                            <h:outputText value="PRESENTACION"/>
                                        </rich:column>
                                        <rich:column>
                                            <h:outputText value="TAMAÑO LOTE DE PRODUCCIÓN"/>
                                        </rich:column>
                                    </rich:columnGroup>
                                </f:facet>
                                    <rich:column>
                                        <h:outputText value="#{data.componentesProdVersion.nombreProdSemiterminado}"/>
                                    </rich:column>
                                    <rich:column>
                                            <h:outputText value="#{data.tiposProgramaProduccion.nombreTipoProgramaProd}"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="#{data.presentacionesProducto.nombreProductoPresentacion}" styleClass="outputText2"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="#{data.cantidadLote}">
                                            <f:convertNumber pattern="#,###,###.##" locale="en"/>
                                        </h:outputText>
                                    </rich:column>
                                
                            </rich:dataTable>
                            <rich:panel headerClass="headerClassACliente" style="width:80%" >
                                <f:facet name="header">
                                    <h:outputText value="Motivo desviación"/>
                                </f:facet>
                                <h:inputTextarea style="width:80%" id="descripcionDesviacion" value="#{ManagedProgramaProduccionDesviacion.desviacionProgramaProduccion.descripcionDesviacion}" styleClass="inputText" rows="3">
                                </h:inputTextarea>
                            </rich:panel>
                        </rich:panel>
                        <rich:tabPanel switchType="client"  activeTabClass="tabActive" style="margin-top:1em;width:auto" inactiveTabClass="tabInactive">
                            
                            <rich:tab label="MATERIA PRIMA" styleClass="tdCenter"  >
                                <rich:tabPanel id="panelMp" switchType="client" selectedTab="#{ManagedProgramaProduccionDesviacion.codCompprodDesviacion}"  activeTabClass="tabActive" style="margin-top:1em;width:auto" inactiveTabClass="tabInactive">
                                    <rich:tab label="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleMpList[0].nombreProdSemiterminado}"
                                              name="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleMpList[0].codCompprod}" >
                                        <h:panelGrid columns="6" style="width:100%">
                                            <h:outputText value="Producto" styleClass="outputTextBold"/>
                                            <h:outputText value="::" styleClass="outputTextBold"/>
                                            <h:outputText value="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleMpList[0].nombreProdSemiterminado}" styleClass="outputText2"/>
                                            <h:outputText value="Tolerancia (%)" styleClass="outputTextBold"/>
                                            <h:outputText value="::" styleClass="outputTextBold"/>
                                            <h:outputText value="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleMpList[0].toleranciaVolumenfabricar}" id="toleranciaVolumenfabricar0" styleClass="outputText2"/>
                                            <h:outputText value="Volumen Teórico (ml)" styleClass="outputTextBold" rendered="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleMpList[0].areasEmpresa.codAreaEmpresa eq '81'}"/>
                                            <h:outputText value="::" styleClass="outputTextBold" rendered="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleMpList[0].areasEmpresa.codAreaEmpresa eq '81'}"/>
                                            <h:outputText value="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleMpList[0].cantidadVolumen}" id="cantidadVolumen0" styleClass="outputText2"  rendered="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleMpList[0].areasEmpresa.codAreaEmpresa eq '81'}"/>
                                            <h:outputText value="Volumen de dosificado (ml)" styleClass="outputTextBold" rendered="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleMpList[0].areasEmpresa.codAreaEmpresa eq '81'}"/>
                                            <h:outputText value="::" styleClass="outputTextBold" rendered="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleMpList[0].areasEmpresa.codAreaEmpresa eq '81'}"/>
                                            <h:outputText value="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleMpList[0].cantidadVolumenDeDosificado}" id="cantidadVolumenDeDosificado0" styleClass="outputText2" rendered="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleMpList[0].areasEmpresa.codAreaEmpresa eq '81'}"/>
                                            <h:outputText value="Tamaño Lote Producción" styleClass="outputTextBold"/>
                                            <h:outputText value="::" styleClass="outputTextBold"/>
                                            <h:outputText value="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleMpList[0].tamanioLoteProduccion}" id="tamanioLoteProduccion0" styleClass="outputText2"/>
                                        </h:panelGrid>
                                        <rich:dataTable value="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleMpList[0].desviacionFormulaMaestraDetalleMpList}"
                                                        var="data" id="dataDetalleFormula" style="margin-top:0.5em"
                                                        onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                                        onRowMouseOver="this.style.backgroundColor='#CCDFFA';" 
                                                        headerClass="headerClassACliente">
                                                <f:facet name="header">
                                                    <rich:columnGroup>
                                                        <rich:column>
                                                            <h:outputText value="Materia Prima"/>
                                                        </rich:column>
                                                        <rich:column>
                                                            <h:outputText value="Cantidad<br>Unitaria<br>Gramos" escape="false" />
                                                        </rich:column>
                                                        <rich:column>
                                                            <h:outputText value="Cantidad<br>Total<br>Gramos" escape="false" />
                                                        </rich:column>
                                                        <rich:column>
                                                            <h:outputText value="Densidad<br>Material<br>(g/ml)" escape="false" />
                                                        </rich:column>
                                                        <rich:column>
                                                            <h:outputText value="Cantidad<br>por<br>lote"  escape="false"/>
                                                        </rich:column>
                                                        <rich:column>
                                                            <h:outputText value="Unidad<br>Medida<br>Almacen"  escape="false" />
                                                        </rich:column>
                                                        <rich:column>
                                                            <h:outputText value="Nro<br>Fracciones"  escape="false" />
                                                        </rich:column>
                                                        <rich:column>
                                                            <h:outputText value="Cantidad<br>Por Fracción<br>Gramos"  escape="false"/>
                                                        </rich:column>
                                                        <rich:column>
                                                            <h:outputText value="Fracciones<br>Gramos"  escape="false"/>
                                                        </rich:column>
                                                        <rich:column>
                                                            <h:outputText value="Estado Material"  />
                                                        </rich:column>
                                                        <rich:column>
                                                            <h:outputText value="Fracciones"/>
                                                        </rich:column>
                                                    </rich:columnGroup>
                                                </f:facet>
                                                <rich:column colspan="12" styleClass="cambioTipoProduccion" >
                                                    <h:outputText value="#{data.nombreTipoMaterialProduccion}"/>
                                                </rich:column>
                                                <rich:subTable value="#{data.formulaMaestraDetalleMPList}" var="subData">
                                                    
                                                    <rich:column >
                                                        <h:outputText value="#{subData.materiales.nombreMaterial}" />
                                                    </rich:column>
                                                    <rich:column styleClass="fondoAmarillo tdRight" >
                                                        <h:outputText value="#{subData.cantidadUnitariaGramos}">
                                                            <f:convertNumber pattern="##0.000000" locale="en"/>
                                                        </h:outputText>
                                                    </rich:column>
                                                    <rich:column styleClass="fondoAmarillo tdRight">
                                                        <h:outputText value="#{subData.cantidadTotalGramos}">
                                                            <f:convertNumber pattern="##0.00" locale="en"/>
                                                        </h:outputText>
                                                    </rich:column>
                                                    <rich:column >
                                                        <h:outputText value="#{subData.densidadMaterial}" rendered="#{subData.unidadesMedida.tipoMedida.codTipoMedida!=2}">
                                                            <f:convertNumber pattern="##0.00#####"/>
                                                        </h:outputText>
                                                    </rich:column>
                                                    <rich:column  styleClass="tdRight">
                                                        <h:outputText value="#{subData.cantidad}" >
                                                            <f:convertNumber pattern="####0.00" locale="en"/>
                                                        </h:outputText>
                                                    </rich:column>
                                                    <rich:column>
                                                        <h:outputText value="#{subData.unidadesMedida.nombreUnidadMedida}" />
                                                    </rich:column>
                                                    <rich:column >
                                                        <h:outputText value="#{subData.formulaMaestraDetalleMPfraccionesListSize}" />
                                                    </rich:column>
                                                    <rich:column >
                                                        <h:outputText value="#{subData.cantidadMaximaMaterialPorFraccion}" rendered="#{subData.cantidadMaximaMaterialPorFraccion>0}" />
                                                        <h:outputText value="N.A." rendered="#{subData.cantidadMaximaMaterialPorFraccion eq 0}" />
                                                    </rich:column>
                                                    <rich:column styleClass="fondoAmarillo tdRight" >
                                                        <h:dataTable value="#{subData.formulaMaestraDetalleMPfraccionesList}" columnClasses="tituloCampo"
                                                                     var="val" id="zonasDetalle" style="width:100%;border:0px solid red;text-align:right;" width="100%" >
                                                            <h:column>
                                                                <h:outputText value="#{val.cantidad}" style="text-align:right;"  styleClass="outputText2">
                                                                    <f:convertNumber locale="en" pattern="####0.00"/>
                                                                </h:outputText>
                                                            </h:column>
                                                        </h:dataTable>
                                                    </rich:column>
                                                    <rich:column >
                                                        <h:outputText value="#{subData.materiales.estadoRegistro.nombreEstadoRegistro}"/>
                                                        
                                                    </rich:column>
                                                    <rich:column>
                                                        <rich:dropDownMenu >
                                                            <f:facet name="label">
                                                                <h:outputText value="Acciones"/>
                                                            </f:facet>
                                                            <rich:menuItem  submitMode="none" value="Editar" >
                                                                <a4j:support event="onclick" reRender="formEditarDesviacionFormulaMaestraDetalleMp"
                                                                             oncomplete="Richfaces.showModalPanel('panelEditarDesviacionFormulaMaestraDetalleMp')">
                                                                    <f:setPropertyActionListener target="#{ManagedProgramaProduccionDesviacion.componentesProdBean}"
                                                                                                 value="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleMpList[0]}"/>          
                                                                    <f:setPropertyActionListener target="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleMpEditar}"
                                                                                                 value="#{subData}"/>
                                                                    <f:setPropertyActionListener target="#{ManagedProgramaProduccionDesviacion.tiposMaterialProduccionBean}"
                                                                                                value="#{data}"/>
                                                                </a4j:support>
                                                            </rich:menuItem>
                                                            <rich:menuItem  submitMode="none" value="Eliminar" >
                                                                <a4j:support event="onclick" reRender="panelMp" action="#{ManagedProgramaProduccionDesviacion.eliminarMaterialesDesviacionFormulaMaestraMP_action}">
                                                                    <f:setPropertyActionListener target="#{ManagedProgramaProduccionDesviacion.tiposMaterialProduccionBean}"
                                                                                             value="#{data}"/>
                                                                    <f:setPropertyActionListener target="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleMpEliminar}"
                                                                                             value="#{subData}"/>
                                                                </a4j:support>
                                                                    
                                                            </rich:menuItem>
                                                            <rich:menuItem  submitMode="none" value="Modificar Fracciones" rendered="#{!subData.aplicaCantidadMaximaPorFraccion}">
                                                                <a4j:support event="onclick" reRender="contenidoModificacionFraccionesFormulaMaestraDetalleMp"
                                                                             oncomplete="Richfaces.showModalPanel('panelModificacionFraccionesFormulaMaestraDetalleMp')">
                                                                    
                                                                    <f:setPropertyActionListener target="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleMpEditarFraccion}"
                                                                                             value="#{subData}"/>
                                                                </a4j:support>
                                                            </rich:menuItem>
                                                            
                                                        </rich:dropDownMenu>
                                                    </rich:column>
                                                </rich:subTable>
                                            <rich:column colspan="2" >
                                                <h:outputText value="Total:" styleClass="outputTextBold"/>
                                            </rich:column>
                                            <rich:column styleClass="tdRight">
                                                <h:outputText value="#{data.cantidadUnitariaMaterialTotal}">
                                                    <f:convertNumber pattern="###0.000000" locale="en"/>
                                                </h:outputText>
                                            </rich:column>
                                            <rich:column>
                                                <h:outputText value="#{data.cantidadMaterialTotal}">
                                                    <f:convertNumber pattern="###0.00" locale="en"/>
                                                </h:outputText>
                                            </rich:column>
                                            <rich:column colspan="10" >
                                            </rich:column>
                                            <f:facet name="footer" >
                                                <rich:columnGroup>
                                                    <rich:column styleClass="footerClass" colspan="12">
                                                            <a4j:commandButton value="Agregar M.P." action="#{ManagedProgramaProduccionDesviacion.agregarDesviacionFormulaMaestraDetalleMP_action}"
                                                                        oncomplete="Richfaces.showModalPanel('panelAgregarDesviacionFormulaMaestraDetalleMp')"
                                                                        styleClass="btn" reRender="contenidoAgregarDesviacionFormulaMaestraDetalleMp">
                                                                <f:setPropertyActionListener target="#{ManagedProgramaProduccionDesviacion.componentesProdBean}"
                                                                                             value="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleMpList[0]}"/>
                                                            </a4j:commandButton>
                                                    </rich:column>
                                                </rich:columnGroup>
                                            </f:facet>
                                        </rich:dataTable>

                                    </rich:tab>
                                    <rich:tab label="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleMpList[1].nombreProdSemiterminado}"
                                              name="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleMpList[1].codCompprod}" rendered="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleMpListSize>1}">
                                        <h:panelGrid columns="6" style="width:100%">
                                            <h:outputText value="Producto" styleClass="outputTextBold"/>
                                            <h:outputText value="::" styleClass="outputTextBold"/>
                                            <h:outputText value="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleMpList[1].nombreProdSemiterminado}" styleClass="outputText2"/>
                                            <h:outputText value="Tolerancia (%)" styleClass="outputTextBold"/>
                                            <h:outputText value="::" styleClass="outputTextBold"/>
                                            <h:outputText value="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleMpList[1].toleranciaVolumenfabricar}" id="toleranciaVolumenfabricar1" styleClass="outputText2"/>
                                            <h:outputText value="Volumen Teórico (ml)" styleClass="outputTextBold" rendered="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleMpList[1].areasEmpresa.codAreaEmpresa eq '81'}"/>
                                            <h:outputText value="::" styleClass="outputTextBold" rendered="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleMpList[1].areasEmpresa.codAreaEmpresa eq '81'}"/>
                                            <h:outputText value="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleMpList[1].cantidadVolumen}" id="cantidadVolumen1" styleClass="outputText2"  rendered="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleMpList[1].areasEmpresa.codAreaEmpresa eq '81'}"/>
                                            <h:outputText value="Volumen de dosificado (ml)" styleClass="outputTextBold" rendered="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleMpList[1].areasEmpresa.codAreaEmpresa eq '81'}"/>
                                            <h:outputText value="::" styleClass="outputTextBold" rendered="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleMpList[1].areasEmpresa.codAreaEmpresa eq '81'}"/>
                                            <h:outputText value="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleMpList[1].cantidadVolumenDeDosificado}" id="cantidadVolumenDeDosificado1" styleClass="outputText2" rendered="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleMpList[1].areasEmpresa.codAreaEmpresa eq '81'}"/>
                                            <h:outputText value="Tamaño Lote Producción" styleClass="outputTextBold"/>
                                            <h:outputText value="::" styleClass="outputTextBold"/>
                                            <h:outputText value="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleMpList[1].tamanioLoteProduccion}" id="tamanioLoteProduccion" styleClass="outputText2"/>
                                        </h:panelGrid>
                                        <rich:dataTable value="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleMpList[1].desviacionFormulaMaestraDetalleMpList}"
                                                        var="data" id="dataDetalleFormula1" style="margin-top:0.5em"
                                                        onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                                        onRowMouseOver="this.style.backgroundColor='#CCDFFA';" 
                                                        headerClass="headerClassACliente">
                                                <f:facet name="header">
                                                    <rich:columnGroup>
                                                        <rich:column>
                                                            <h:outputText value="Materia Prima"/>
                                                        </rich:column>
                                                        <rich:column>
                                                            <h:outputText value="Cantidad<br>Unitaria<br>Gramos" escape="false" />
                                                        </rich:column>
                                                        <rich:column>
                                                            <h:outputText value="Cantidad<br>Total<br>Gramos" escape="false" />
                                                        </rich:column>
                                                        <rich:column>
                                                            <h:outputText value="Densidad<br>Material<br>(g/ml)" escape="false" />
                                                        </rich:column>
                                                        <rich:column>
                                                            <h:outputText value="Cantidad<br>por<br>lote"  escape="false"/>
                                                        </rich:column>
                                                        <rich:column>
                                                            <h:outputText value="Unidad<br>Medida<br>Almacen"  escape="false" />
                                                        </rich:column>
                                                        <rich:column>
                                                            <h:outputText value="Nro<br>Fracciones"  escape="false" />
                                                        </rich:column>
                                                        <rich:column>
                                                            <h:outputText value="Cantidad<br>Por Fracción<br>Gramos"  escape="false"/>
                                                        </rich:column>
                                                        <rich:column>
                                                            <h:outputText value="Fracciones<br>Gramos"  escape="false"/>
                                                        </rich:column>
                                                        <rich:column>
                                                            <h:outputText value="Estado Material"  />
                                                        </rich:column>
                                                        <rich:column>
                                                            <h:outputText value="Fracciones"/>
                                                        </rich:column>
                                                    </rich:columnGroup>
                                                </f:facet>
                                                <rich:column colspan="12" styleClass="cambioTipoProduccion" >
                                                    <h:outputText value="#{data.nombreTipoMaterialProduccion}"/>
                                                </rich:column>
                                                <rich:subTable value="#{data.formulaMaestraDetalleMPList}" var="subData">
                                                    <rich:column >
                                                        <h:outputText value="#{subData.materiales.nombreMaterial}" />
                                                    </rich:column>
                                                    <rich:column styleClass="fondoAmarillo tdRight" >
                                                        <h:outputText value="#{subData.cantidadUnitariaGramos}">
                                                            <f:convertNumber pattern="##0.000000" locale="en"/>
                                                        </h:outputText>
                                                    </rich:column>
                                                    <rich:column styleClass="fondoAmarillo tdRight">
                                                        <h:outputText value="#{subData.cantidadTotalGramos}">
                                                            <f:convertNumber pattern="##0.00" locale="en"/>
                                                        </h:outputText>
                                                    </rich:column>
                                                    <rich:column >
                                                        <h:outputText value="#{subData.densidadMaterial}" rendered="#{subData.unidadesMedida.tipoMedida.codTipoMedida!=2}">
                                                            <f:convertNumber pattern="##0.00#####"/>
                                                        </h:outputText>
                                                    </rich:column>
                                                    <rich:column  styleClass="tdRight">
                                                        <h:outputText value="#{subData.cantidad}" >
                                                            <f:convertNumber pattern="####0.00" locale="en"/>
                                                        </h:outputText>
                                                    </rich:column>
                                                    <rich:column>
                                                        <h:outputText value="#{subData.unidadesMedida.nombreUnidadMedida}" />
                                                    </rich:column>
                                                    <rich:column >
                                                        <h:outputText value="#{subData.formulaMaestraDetalleMPfraccionesListSize}" />
                                                    </rich:column>
                                                    <rich:column >
                                                        <h:outputText value="#{subData.cantidadMaximaMaterialPorFraccion}" rendered="#{subData.cantidadMaximaMaterialPorFraccion>0}" />
                                                        <h:outputText value="N.A." rendered="#{subData.cantidadMaximaMaterialPorFraccion eq 0}" />
                                                    </rich:column>
                                                    <rich:column styleClass="fondoAmarillo tdRight" >
                                                        <h:dataTable value="#{subData.formulaMaestraDetalleMPfraccionesList}" columnClasses="tituloCampo"
                                                                     var="val" id="zonasDetalle" style="width:100%;border:0px solid red;text-align:right;" width="100%" >
                                                            <h:column>
                                                                <h:outputText value="#{val.cantidad}" style="text-align:right;"  styleClass="outputText2">
                                                                    <f:convertNumber locale="en" pattern="####0.00"/>
                                                                </h:outputText>
                                                            </h:column>
                                                        </h:dataTable>
                                                    </rich:column>
                                                    <rich:column >
                                                        <h:outputText value="#{subData.materiales.estadoRegistro.nombreEstadoRegistro}"/>
                                                        
                                                    </rich:column>
                                                    <rich:column>
                                                        <rich:dropDownMenu >
                                                            <f:facet name="label">
                                                                <h:outputText value="Acciones"/>
                                                            </f:facet>
                                                            <rich:menuItem  submitMode="none" value="Editar" >
                                                                <a4j:support event="onclick" reRender="formEditarDesviacionFormulaMaestraDetalleMp"
                                                                             oncomplete="Richfaces.showModalPanel('panelEditarDesviacionFormulaMaestraDetalleMp')">
                                                                    <f:setPropertyActionListener target="#{ManagedProgramaProduccionDesviacion.componentesProdBean}"
                                                                                                 value="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleMpList[1]}"/>          
                                                                    <f:setPropertyActionListener target="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleMpEditar}"
                                                                                                 value="#{subData}"/>
                                                                    <f:setPropertyActionListener target="#{ManagedProgramaProduccionDesviacion.tiposMaterialProduccionBean}"
                                                                                                value="#{data}"/>
                                                                </a4j:support>
                                                            </rich:menuItem>
                                                            <rich:menuItem  submitMode="none" value="Eliminar" >
                                                                <a4j:support event="onclick" reRender="panelMp" action="#{ManagedProgramaProduccionDesviacion.eliminarMaterialesDesviacionFormulaMaestraMP_action}">
                                                                    <f:setPropertyActionListener target="#{ManagedProgramaProduccionDesviacion.tiposMaterialProduccionBean}"
                                                                                             value="#{data}"/>
                                                                    <f:setPropertyActionListener target="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleMpEliminar}"
                                                                                             value="#{subData}"/>
                                                                </a4j:support>
                                                                    
                                                            </rich:menuItem>
                                                            <rich:menuItem  submitMode="none" value="Modificar Fracciones" rendered="#{!subData.aplicaCantidadMaximaPorFraccion}">
                                                                <a4j:support event="onclick" reRender="contenidoModificacionFraccionesFormulaMaestraDetalleMp"
                                                                             oncomplete="Richfaces.showModalPanel('panelModificacionFraccionesFormulaMaestraDetalleMp')">
                                                                    
                                                                    <f:setPropertyActionListener target="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleMpEditarFraccion}"
                                                                                             value="#{subData}"/>
                                                                </a4j:support>
                                                            </rich:menuItem>
                                                            
                                                        </rich:dropDownMenu>
                                                    </rich:column>
                                                </rich:subTable>
                                            <rich:column colspan="2" >
                                                <h:outputText value="Total:" styleClass="outputTextBold"/>
                                            </rich:column>
                                            <rich:column styleClass="tdRight">
                                                <h:outputText value="#{data.cantidadUnitariaMaterialTotal}">
                                                    <f:convertNumber pattern="###0.000000" locale="en"/>
                                                </h:outputText>
                                            </rich:column>
                                            <rich:column>
                                                <h:outputText value="#{data.cantidadMaterialTotal}">
                                                    <f:convertNumber pattern="###0.00" locale="en"/>
                                                </h:outputText>
                                            </rich:column>
                                            <rich:column colspan="10" >
                                            </rich:column>
                                            <f:facet name="footer" >
                                                <rich:columnGroup>
                                                    <rich:column styleClass="footerClass" colspan="12">
                                                            <a4j:commandButton value="Agregar M.P." action="#{ManagedProgramaProduccionDesviacion.agregarDesviacionFormulaMaestraDetalleMP_action}"
                                                                        oncomplete="Richfaces.showModalPanel('panelAgregarDesviacionFormulaMaestraDetalleMp')"
                                                                        styleClass="btn" reRender="contenidoAgregarDesviacionFormulaMaestraDetalleMp">
                                                                <f:setPropertyActionListener target="#{ManagedProgramaProduccionDesviacion.componentesProdBean}"
                                                                                             value="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleMpList[1]}"/>
                                                            </a4j:commandButton>
                                                    </rich:column>
                                                </rich:columnGroup>
                                            </f:facet>
                                        </rich:dataTable>

                                    </rich:tab>
                                </rich:tabPanel>
                                    
                                
                                
                                                            
                            </rich:tab>
                            <rich:tab label="EMPAQUE PRIMARIO" >
                                <rich:dataTable value="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraEpList}" var="data"
                                            id="dataMaterialesEP" 
                                            onRowMouseOut="this.style.backgroundColor='#FFFFFF';" rowKeyVar="var"
                                            onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                            headerClass="headerClassACliente">
                                    <f:facet name="header">
                                        <rich:columnGroup>
                                            <rich:column colspan="6">
                                                <h:outputText value="Empaque Primario"/>
                                            </rich:column>
                                        </rich:columnGroup>
                                    </f:facet>
                                        <rich:column styleClass="cambioPresentacion tdCenter" colspan="6">
                                            <h:panelGrid columns="3" style="width:100%">
                                                <h:outputText value="Tipo Produccion" styleClass="outputTextBold"/>
                                                <h:outputText value="::" styleClass="outputTextBold"/>
                                                <h:outputText value="#{data.tiposProgramaProduccion.nombreTipoProgramaProd}" styleClass="outputText2"/>
                                                <h:outputText value="Envase" styleClass="outputTextBold"/>
                                                <h:outputText value="::" styleClass="outputTextBold"/>
                                                <h:outputText value="#{data.envasesPrimarios.nombreEnvasePrim}" styleClass="outputText2"/>
                                                <h:outputText value="Cantidad Por Envase" styleClass="outputTextBold"/>
                                                <h:outputText value="::" styleClass="outputTextBold"/>
                                                <h:outputText value="#{data.cantidad}" styleClass="outputText2"/>
                                                <h:outputText value="Cantidad Lote" styleClass="outputTextBold"/>
                                                <h:outputText value="::" styleClass="outputTextBold"/>
                                                <h:outputText value="#{data.cantidadLote}" styleClass="outputText2"/>
                                                <h:outputText value="Cantidad Presentaciones Primarias" styleClass="outputTextBold"/>
                                                <h:outputText value="::" styleClass="outputTextBold"/>
                                                <h:outputText value="#{data.cantidadPresentacionesPrimarias}" styleClass="outputText2"/>
                                            </h:panelGrid>
                                            <a4j:commandButton value="Agregar E.P." action="#{ManagedProgramaProduccionDesviacion.agregarDesviacionFormulaMaestraDetalleEp_action}"
                                                            oncomplete="Richfaces.showModalPanel('panelAgregarDesviacionFormulaMaestraDetalleEp')"
                                                            styleClass="btn" reRender="contenidoAgregarDesviacionFormulaMaestraDetalleEp">
                                                <f:setPropertyActionListener target="#{ManagedProgramaProduccionDesviacion.presentacionesPrimariasBean}"
                                                                                     value="#{data}"/>  
                                            </a4j:commandButton>
                                        </rich:column>
                                        <rich:columnGroup>
                                            
                                            <rich:column breakBefore="true" styleClass="headerClassACliente">
                                                <h:outputText value="Material" />
                                            </rich:column>
                                            <rich:column styleClass="headerClassACliente">
                                                <h:outputText value="Cantidad Unitaria"/>
                                            </rich:column>
                                            
                                            <rich:column styleClass="headerClassACliente">
                                                <h:outputText value="Cantidad<br>Total" escape="false"/>
                                            </rich:column>
                                            <rich:column styleClass="headerClassACliente">
                                                <h:outputText value="Unidad<br>Medida" escape="false"/>
                                            </rich:column>
                                            <rich:column  styleClass="headerClassACliente">
                                                <h:outputText value="Acciones"/>
                                            </rich:column>
                                        </rich:columnGroup>
                                    <rich:subTable value="#{data.desviacionFormulaMaestraDetalleEpList}" var="subData" 
                                                   rowKeyVar="var">
                                       
                                        <rich:column  breakBefore="true" style="text-align:center" >
                                            <h:outputText value="#{subData.materiales.nombreMaterial}" styleClass="outputText2"/>
                                        </rich:column>
                                        <rich:column  style="text-align:center" >
                                            <h:outputText value="#{subData.cantidadUnitaria}" styleClass="outputText2"/>
                                        </rich:column>
                                        <rich:column>
                                            <h:outputText value="#{subData.cantidad}" styleClass="outputText2"/>
                                        </rich:column>
                                        <rich:column  style="text-align:center" >
                                            <h:outputText value="#{subData.unidadesMedida.nombreUnidadMedida}" styleClass="outputText2"/>
                                        </rich:column>
                                        <rich:column>
                                            <rich:dropDownMenu >
                                                <f:facet name="label">
                                                    <h:outputText value="Acciones"/>
                                                </f:facet>
                                                <rich:menuItem  submitMode="none" value="Editar" >
                                                    <a4j:support event="onclick" reRender="contenidoEditarDesviacionFormulaMaestraDetalleEp"
                                                                 oncomplete="Richfaces.showModalPanel('panelEditarDesviacionFormulaMaestraDetalleEp')">
                                                        <f:setPropertyActionListener target="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleEpEditar}"
                                                                                     value="#{subData}"/> 
                                                        <f:setPropertyActionListener target="#{ManagedProgramaProduccionDesviacion.presentacionesPrimariasBean}"
                                                                                     value="#{data}"/>  
                                                        
                                                    </a4j:support>
                                                </rich:menuItem>
                                                <rich:menuItem  submitMode="none" value="Eliminar" >
                                                    <a4j:support event="onclick" reRender="dataMaterialesEP"
                                                                 action="#{ManagedProgramaProduccionDesviacion.eliminarDesviacionFormulaMaestraDetalleEp_action}">
                                                        <f:setPropertyActionListener target="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleEpEliminar}"
                                                                                     value="#{subData}"/>          
                                                        <f:setPropertyActionListener target="#{ManagedProgramaProduccionDesviacion.presentacionesPrimariasBean}"
                                                                                     value="#{data}"/>  
                                                    </a4j:support>
                                                </rich:menuItem>
                                                
                                            </rich:dropDownMenu>
                                        </rich:column>
                                    </rich:subTable>
                                </rich:dataTable>
                            </rich:tab>
                            <rich:tab label="EMPAQUE SECUNDARIO" >
                                <rich:dataTable value="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraEsList}" var="data"
                                            id="dataMaterialesES" 
                                            onRowMouseOut="this.style.backgroundColor='#FFFFFF';" rowKeyVar="var"
                                            onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                            headerClass="headerClassACliente">
                                    <f:facet name="header">
                                        <rich:columnGroup>
                                            <rich:column colspan="4">
                                                <h:outputText value="Empaque Secundario"/>
                                            </rich:column>
                                            <rich:column breakBefore="true">
                                                <h:outputText value="Material"/>
                                            </rich:column>
                                            <rich:column>
                                                <h:outputText value="Cantidad"/>
                                            </rich:column>
                                            <rich:column>
                                                <h:outputText value="Unidad Medida"/>
                                            </rich:column>
                                            <rich:column>
                                                <h:outputText value="Acciones"/>
                                            </rich:column>
                                            
                                        </rich:columnGroup>
                                    </f:facet>
                                    <rich:column styleClass="cambioPresentacion"  colspan="4">
                                        <h:outputText value="#{data.tiposProgramaProduccion.nombreTipoProgramaProd}<br>" escape="false"/>
                                        <h:outputText value="#{data.presentacionesProducto.nombreProductoPresentacion}<br/>" escape="false"/>
                                        <a4j:commandButton value="Agregar E.S." action="#{ManagedProgramaProduccionDesviacion.agregarDesviacionFormulaMaestraDetalleEs_action}"
                                                    oncomplete="Richfaces.showModalPanel('panelAgregarDesviacionFormulaMaestraDetalleEs')"
                                                    styleClass="btn" reRender="contenidoAgregarDesviacionFormulaMaestraDetalleEs">
                                            <f:setPropertyActionListener value="#{data}" target="#{ManagedProgramaProduccionDesviacion.componentesPresProdBean}"/>
                                        </a4j:commandButton>
                                    </rich:column>
                                    <rich:subTable value="#{data.desviacionFormulaMaestraDetalleEsList}" var="subData" 
                                                   rowKeyVar="var">
                                        <rich:column  style="text-align:center" >
                                            <h:outputText value="#{subData.materiales.nombreMaterial}" styleClass="outputText2"/>
                                        </rich:column>
                                        <rich:column  style="text-align:center" >
                                            <h:outputText value="#{subData.cantidad}" styleClass="outputText2"/>
                                        </rich:column>
                                        <rich:column  style="text-align:center" >
                                            <h:outputText value="#{subData.unidadesMedida.nombreUnidadMedida}" styleClass="outputText2"/>
                                        </rich:column>
                                        <rich:column>
                                            <rich:dropDownMenu >
                                                <f:facet name="label">
                                                    <h:outputText value="Acciones"/>
                                                </f:facet>
                                                <rich:menuItem  submitMode="none" value="Editar" >
                                                    <a4j:support event="onclick" reRender="contenidoEditarDesviacionFormulaMaestraDetalleEs"
                                                                 oncomplete="Richfaces.showModalPanel('panelEditarDesviacionFormulaMaestraDetalleEs')">
                                                        <f:setPropertyActionListener target="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleEsEditar}"
                                                                                     value="#{subData}"/>          
                                                        <f:setPropertyActionListener value="#{data}" target="#{ManagedProgramaProduccionDesviacion.componentesPresProdBean}"/>
                                                    </a4j:support>
                                                </rich:menuItem>
                                                <rich:menuItem  submitMode="none" value="Eliminar" >
                                                    <a4j:support event="onclick" reRender="dataMaterialesES"
                                                                 action="#{ManagedProgramaProduccionDesviacion.eliminarDesviacionFormulaMaestraDetalleEs_action}">
                                                        <f:setPropertyActionListener target="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleEsEliminar}"
                                                                                     value="#{subData}"/>          
                                                        <f:setPropertyActionListener target="#{ManagedProgramaProduccionDesviacion.componentesPresProdBean}"
                                                                                     value="#{data}"/>  
                                                    </a4j:support>
                                                </rich:menuItem>
                                                
                                            </rich:dropDownMenu>
                                        </rich:column>
                                    </rich:subTable>
                                </rich:dataTable>
                                
                            </rich:tab>
                                    
                        </rich:tabPanel>
                        
                     </h:panelGroup>
                     <br/>
                     <a4j:commandButton value="Guardar Desviación"  styleClass="btn"  action="#{ManagedProgramaProduccionDesviacion.guardarDesviacionProgramaProduccionMaterial_action}"
                    oncomplete="if(#{ManagedProgramaProduccionDesviacion.mensaje eq '1'}){alert('Se registro la desviación');window.location.href='../navegadorProgramaProduccion.jsf?data='+(new Date()).getTime().toString();}else{alert('#{ManagedProgramaProduccionDesviacion.mensaje}');}"/>
                    <input type="button" class="btn" onclick="window.location.href='../navegadorProgramaProduccion.jsf?cancel='+(new Date()).getTime().toString();" value="Cancelar" />
                    

                </div>
                
            </a4j:form>
            <rich:modalPanel id="panelDescribirDesviaciónPlanificada"
                             minHeight="280"  minWidth="700"
                             height="280" width="700" zindex="200"
                             headerClass="headerClassACliente"
                             resizeable="false">
                <f:facet name="header">
                    <h:outputText value="<center>Agregar Material de Empaque Secundario</center>" escape="false" />
                </f:facet>
                <a4j:form id="formDescribirDesviaciónPlanificada">
                        
                </a4j:form>
            </rich:modalPanel>
            
                
            
            
                
                
                    <rich:modalPanel id="panelCambiarPresentacionSecundaria"
                                    minHeight="280"  minWidth="350"
                                    height="280" width="350" zindex="200"
                                    headerClass="headerClassACliente"
                                    resizeable="false">
                       <f:facet name="header">
                           <h:outputText value="<center>Seleccionar Presentación Secundaria</center>" escape="false" />
                       </f:facet>
                       <a4j:form id="contenidoCambiarPresentacionSecundaria">
                           <center>
                               <rich:dataTable value="#{ManagedProgramaProduccionDesviacion.componentesPresProdDesviacionList}"
                                            var="data" id="dataPresentaciones" rowKeyVar="var"
                                            headerClass="headerClassACliente"
                                            onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                            onRowMouseOver="this.style.backgroundColor='#DDE3E4';">
                                      <f:facet name="header">
                                          <rich:columnGroup>
                                            <rich:column >
                                                <h:outputText value="Nro Versión"/>
                                            </rich:column>
                                            <rich:column >
                                                <h:outputText value="Presentación" escape="false"/>
                                            </rich:column>
                                        </rich:columnGroup>
                                      </f:facet>
                                            <rich:column>
                                                <h:outputText value="#{data.componentesProd.nroVersion}"/>
                                            </rich:column>
                                            <rich:column>
                                                <a4j:commandLink action="#{ManagedProgramaProduccionDesviacion.seleccionarPresentacionSecundariaDesviacion_action}"
                                                                 oncomplete="javascript:Richfaces.hideModalPanel('panelCambiarPresentacionSecundaria');" reRender="datosLoteProduccion,dataMaterialesES">
                                                            <h:outputText value="#{data.presentacionesProducto.nombreProductoPresentacion}" />
                                                            <f:param name="codVersionProducto" value="#{data.componentesProd.codVersion}"/>
                                                            <f:param name="codPresentacionProducto" value="#{data.presentacionesProducto.codPresentacion}"/>
                                                            <f:param name="nombrePresentacionProducto" value="#{data.presentacionesProducto.nombreProductoPresentacion}"/>
                                                </a4j:commandLink>
                                            </rich:column>
                                </rich:dataTable>
                               <a4j:commandButton value="Cancelar" style="margin-top:1em" oncomplete="javascript:Richfaces.hideModalPanel('panelCambiarPresentacionSecundaria');" styleClass="btn"/>
                           </center>
                       </a4j:form>
                   </rich:modalPanel>
                    <a4j:status id="statusPeticion"
                                onstart="Richfaces.showModalPanel('ajaxLoadingModalBox',{width:100, top:100})"
                                onstop="Richfaces.hideModalPanel('ajaxLoadingModalBox');cargarChosen();">
                     </a4j:status>

                    <rich:modalPanel id="ajaxLoadingModalBox" minHeight="100"
                                     minWidth="200" height="80" width="400" zindex="500" onshow="window.focus();">

                        <div align="center">
                            <h:graphicImage value="../../img/load2.gif" />
                        </div>
                    </rich:modalPanel>
                <a4j:include viewId="desviacionFormulaMaestraDetalleMpAgregar.jsp" id="agregarMP"/>
                <a4j:include viewId="desviacionFormulaMaestraDetalleMpEditar.jsp" id="editarMP"/>
                <a4j:include viewId="desviacionFormulaMaestraDetalleMpFracciones.jsp" id="editarFraccion"/>
                <a4j:include viewId="desviacionFormulaMaestraDetalleEsAgregar.jsp" id="agregarEs"/>    
                <a4j:include viewId="desviacionFormulaMaestraDetalleEsEditar.jsp" id="editarEs"/>    
                <a4j:include viewId="desviacionFormulaMaestraDetalleEpAgregar.jsp" id="agregarEp"/>
                <a4j:include viewId="desviacionFormulaMaestraDetalleEpEditar.jsp" id="editarEp"/>

            
        <a4j:loadScript src="../../js/chosen.js" />
        </f:view>
        </body>
    </html>
    


