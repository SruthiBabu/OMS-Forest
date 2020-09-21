<?xml version = "1.0" encoding = "UTF-8"?>
<xsl:stylesheet xmlns:xsl = "http://www.w3.org/1999/XSL/Transform" version = "1.0">
	<xsl:template match="Print | Batch | Task">
		<PrintDocuments>
		<xsl:attribute name="FlushToPrinter"><xsl:text>Y</xsl:text></xsl:attribute>
		<xsl:attribute name="PrintAfresh"><xsl:text>Y</xsl:text></xsl:attribute>
		<xsl:attribute name="PrintName"><xsl:text>TaskList</xsl:text></xsl:attribute>
			<PrintDocument>
				<xsl:attribute name="BeforeChildrenPrintDocumentId">TASKLIST</xsl:attribute>
				<xsl:attribute name="DataElementPath">xml:/Batch</xsl:attribute>
				<PrinterPreference>
					<xsl:attribute name="UserId"><xsl:text>xml:/Batch/@Modifyuserid</xsl:text></xsl:attribute>
					<xsl:attribute name="UsergroupId"/>
					<xsl:attribute name="WorkStationId"/>
					<xsl:attribute name="OrganizationCode"><xsl:text>xml:/Batch/@OrganizationCode</xsl:text></xsl:attribute>
				</PrinterPreference>
				<LabelPreference>
					<xsl:attribute name="Node">xml:/Batch/@Node</xsl:attribute>
					<xsl:attribute name="EquipmentType">xml:/Batch/@EquipmentType</xsl:attribute>
				</LabelPreference>
				<KeyAttributes>
					<KeyAttribute>
						<xsl:attribute name="Name"><xsl:text>BatchNo</xsl:text></xsl:attribute>
					</KeyAttribute>	
				</KeyAttributes>
				<InputData>
				<xsl:attribute name="FlowName">
					<xsl:text>GetTaskTypesForTaskList</xsl:text>
				</xsl:attribute>
				<Task>
					<xsl:attribute name="PredecessorTaskId">
						  <xsl:value-of select="@TaskId"/>
					</xsl:attribute>
					<TaskType>
						 <xsl:attribute name="BatchRequired">
							  <xsl:text>Y</xsl:text>
						</xsl:attribute>
						<xsl:attribute name="ExecutionDevice">
						  <xsl:text>Ticket</xsl:text>
						</xsl:attribute>
					</TaskType>
				</Task>
				<Template>
				 <Api>
					<xsl:attribute name="Name"><xsl:text>getTaskList</xsl:text></xsl:attribute>	
				 <Template>
				 <TaskList>
					<Task TaskKey="" TaskId="" TaskType="">
						<TaskType/>
					</Task>
				 </TaskList>	
				</Template>
				</Api>
				</Template>
				<InputData>
					<xsl:attribute name="FlowName">
						<xsl:text>CreateBatchForTaskList</xsl:text>
					</xsl:attribute>
					<xsl:attribute name="ParentDataElement">
						<xsl:text>TaskType</xsl:text>
					</xsl:attribute>
					<Task>
						<xsl:attribute name="PredecessorTaskId">
							  <xsl:value-of select="@TaskId"/>
						</xsl:attribute>
						 <xsl:attribute name="TaskType">
							  <xsl:text>@TaskType</xsl:text>
						</xsl:attribute>
						<ComplexQuery>
							<xsl:attribute name="Operator">
								  <xsl:text>AND</xsl:text>
							</xsl:attribute>
							<And>
								<Or>
									<Exp>
										<xsl:attribute name="Name">
											  <xsl:text>TaskStatus</xsl:text>
										</xsl:attribute>										
										<xsl:attribute name="Value">
											  <xsl:text>1100</xsl:text>
										</xsl:attribute>										
									</Exp>
									<Exp>
										<xsl:attribute name="Name">
											  <xsl:text>TaskStatus</xsl:text>
										</xsl:attribute>										
										<xsl:attribute name="Value">
											  <xsl:text>1400</xsl:text>
										</xsl:attribute>										
									</Exp>
								</Or>
						  </And>
						</ComplexQuery>
						<TaskReferences>
							<xsl:attribute name="BatchNoQryType">
							  <xsl:text>VOID</xsl:text>
							</xsl:attribute>
						</TaskReferences>
						<TaskType>
							 <xsl:attribute name="TaskType">
								  <xsl:text>@TaskType</xsl:text>
							</xsl:attribute>
						</TaskType>
					</Task>
					<Template>
					 <Api>
						<xsl:attribute name="Name"><xsl:text>getTaskList</xsl:text></xsl:attribute>	
					 <Template>
					 <TaskList>
						<Task TaskKey="" TaskId="" TaskType="" OrganizationCode="" >
							<TaskReferences />
						</Task>
					 </TaskList>	
					</Template>
					</Api>
					 <Api>
						<xsl:attribute name="Name"><xsl:text>createBatch</xsl:text></xsl:attribute>	
					 <Template>
					 <Batch BatchKey="" BatchNo=""/>
					</Template>
					</Api>
					 <Api>
						<xsl:attribute name="Name"><xsl:text>getBatchList</xsl:text></xsl:attribute>	
					 <Template>
					  <BatchList>
						 <Batch BatchKey="" BatchNo=""/>
					  </BatchList>	
					</Template>
					</Api>
					</Template>
					<InputData>
						<xsl:attribute name="FlowName">
							<xsl:text>GetTaskListData</xsl:text>
						</xsl:attribute>
						<xsl:attribute name="ParentDataElement">
							<xsl:text>Batch</xsl:text>
						</xsl:attribute>
						<Batch>
							<xsl:attribute name="BatchKey"><xsl:text>@BatchKey</xsl:text></xsl:attribute> 
						</Batch>
					<Template>
					 <Api>
						<xsl:attribute name="Name"><xsl:text>getBatchDetails</xsl:text></xsl:attribute>	
					  <Template>
						<Batch ActivityGroupId="" BatchKey="" ReceiptNo="" BatchNo="" BatchStatusDesc="" CountRequestNo="" EquipmentType="" MoveRequestNo="" Node="" OrganizationCode="" ShipmentNo="" Status="" TaskType="" WaveNo="" Modifyuserid="">
						<EquipmentType>
							<EquipmentTypeDetails>
								<EquipmentTypeDetail/>
							</EquipmentTypeDetails>
						</EquipmentType>
						<BatchLocations>
							<BatchLocation CartLocationId="" SlotNumber="" ShipmentKey="" ShipmentContainerKey="">
								<Container ShipmentContainerKey="" ContainerNo="">
									<Corrugation ItemID=""/>
								</Container>
							</BatchLocation>
						</BatchLocations>
						<Tasks>
							<Task SourceLocationId="" SourceZoneId="" SourceSortSequence="" TargetZoneId="" TargetLocationId=""  TargetSortSequence="" OrganizationCode="" TaskStatus="" TargetLPNNo="">
								<Inventory SourceCaseId=""  SourcePalletId="" TargetCaseId="" TargetPalletId=""  ItemId="" UnitOfMeasure="" ProductClass="" Quantity="" TagNumber="" SerialNo="">
									<TagAttributes/>
									<Item ItemID="" UnitOfMeasure="">
										<PrimaryInformation Description=""/>
									</Item>
								</Inventory>
								<TaskReferences ReceiptNo="" WaveNo="" BatchNo="" MoveRequestNo="" ShipmentNo="" CountRequestNo="" ShipmentContainerKey="" ShipmentKey=""/>
								<BatchLocation/>
								<Shipment ShipmentKey="" ShipmentSortLocationId=""/>
								<PredecessorTask TaskId="" TargetPalletId="" TargetCaseId="">
								  <Inventory SourceCaseId="" SourcePalletId="" /> 
								  </PredecessorTask>
							</Task>
						</Tasks>
						</Batch>
						</Template>
					 </Api>	
					</Template>
					</InputData>
				</InputData>
			  </InputData>
			</PrintDocument>
		</PrintDocuments>
	</xsl:template>
</xsl:stylesheet>
