<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="zh">

<head>

<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="">
<meta name="author" content="">

<title>Topic Hub - KafkaEagle</title>
<jsp:include page="../public/plus/css.jsp">
	<jsp:param value="plugins/select2/select2.min.css" name="css" />
</jsp:include>
<jsp:include page="../public/plus/tcss.jsp"></jsp:include>
</head>
<style>
.CodeMirror {
	border-top: 1px solid #ddd;
	border-bottom: 1px solid #ddd;
	border-right: 1px solid #ddd;
	border-left: 1px solid #ddd;
}
</style>
<body>
<jsp:include page="../public/plus/navtop.jsp"></jsp:include>
	<div id="layoutSidenav">
		<div id="layoutSidenav_nav">
			<jsp:include page="../public/plus/navbar.jsp"></jsp:include>
		</div>
		<div id="layoutSidenav_content">
			<main>
				<div class="container-fluid">
					<h1 class="mt-4">Topic</h1>
					<ol class="breadcrumb mb-4">
						<li class="breadcrumb-item"><a href="#">Topic</a></li>
						<li class="breadcrumb-item active">Hub</li>
					</ol>
					<div class="alert alert-info alert-dismissable">
						<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
						<i class="fas fa-info-circle"></i> <strong>It is used to migrate the topic data or balance the expanded broker.</strong>
					</div>
					<!-- content body -->
					<div class="row">
						<div class="col-lg-12">
							<div class="card mb-4">
								<div class="card-header">
									<i class="fas fa-filter"></i> Topic Balance
								</div>
								<div class="card-body">
									<div class="row">
										<div class="col-lg-12">
											<form role="form" action="/topic/create/form" method="post" onsubmit="return contextFormValid();return false;">
												<div class="form-group">
													<label>Topic Name (*)</label>
													<input id="ke_topic_name" name="ke_topic_name" class="form-control" maxlength=50>
													<label for="inputError" class="control-label text-danger">
														<i class="fa fa-info-circle"></i> Made up of letters and digits or underscores . Such as "demo_kafka_topic_1" .
													</label>
												</div>
												<div class="form-group">
													<label>Partitions (*)</label>
													<input id="ke_topic_partition" name="ke_topic_partition" class="form-control" maxlength=50 value="1">
													<label for="inputError" class="control-label text-danger">
														<i class="fa fa-info-circle"></i> Partition parameters must be numeric .
													</label>
												</div>
												<div class="form-group">
													<label>Replication Factor (*)</label>
													<input id="ke_topic_repli" name="ke_topic_repli" class="form-control" maxlength=50 value="1">
													<label for="inputError" class="control-label text-danger">
														<i class="fa fa-info-circle"></i> Replication Factor parameters must be numeric . Pay attention to available brokers must be larger than replication factor .
													</label>
												</div>
												<button type="submit" class="btn btn-success">Create</button>
												<div id="create_alert_msg" style="display: none" class="alert alert-danger">
													<label>Error! Please make some changes. (*) is required.</label>
												</div>
											</form>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</main>
			<jsp:include page="../public/plus/footer.jsp"></jsp:include>
		</div>
	</div>
	<jsp:include page="../public/navbar.jsp"></jsp:include>
	<div id="wrapper">
		<div id="page-wrapper">
			<!-- /.row -->
			<!-- /.row -->
			<div class="row">
				<div class="col-lg-12">
					<div class="panel panel-default">
						<div class="panel-heading">
							<i class="fa fa-filter fa-fw"></i> Topic Balance
							<div class="pull-right"></div>
						</div>
						<!-- /.panel-heading -->
						<div class="panel-body">
							<div class="row">
								<div class="col-lg-12">
									<div class="form-group">
										<label>Balance Type (*)</label>
										<br />
										<label class="radio-inline">
											<input type="radio" name="ke_topic_balance_type" id="ke_topic_balance_type_single" value="balance_single" checked="">Single
										</label>
										<label class="radio-inline">
											<input type="radio" name="ke_topic_balance_type" id="ke_topic_balance_type_all" value="balance_all">All
										</label>
										<br />
										<br />
										<label>Topic Name (*)</label>
										<select multiple="multiple" id="select2val" name="select2val" tabindex="-1" style="width: 100%; font-family: 'Microsoft Yahei', 'HelveticaNeue', Helvetica, Arial, sans-serif; font-size: 1px;"></select>
										<input id="ke_topic_balance" name="ke_topic_balance" type="hidden" />
										<label for="inputError" class="control-label text-danger">
											<i class="fa fa-info-circle"></i> Select the topic you need to balance .
										</label>
									</div>
									<button id="ke_balancer_generate" class="btn btn-success">Generate</button>
									<button id="ke_balancer_execute" class="btn btn-primary" style="display: none">Execute</button>
									<button id="ke_balancer_verify" class="btn btn-info" style="display: none">Verify</button>
								</div>
							</div>
							<!-- /.panel-body -->
						</div>
					</div>
					<!-- /.col-lg-4 -->
				</div>
				<!-- /.row -->
			</div>
			<!-- /.row -->
			<div class="row">
				<div class="col-lg-6">
					<div class="panel panel-default">
						<div class="panel-heading">
							<i class="fa fa-tasks fa-fw"></i> Proposed Partition Reassignment Configuartion
							<div class="pull-right"></div>
						</div>
						<!-- /.panel-heading -->
						<div class="panel-body">
							<div id="ke_sql_query">
								<form>
									<textarea id="code_proposed" name="code_proposed"></textarea>
								</form>
							</div>
						</div>
						<!-- /.panel-body -->
					</div>
				</div>
				<div class="col-lg-6">
					<div class="panel panel-default">
						<div class="panel-heading">
							<i class="fa fa-tasks fa-fw"></i> Current Partition Replica Assignment
							<div class="pull-right"></div>
						</div>
						<!-- /.panel-heading -->
						<div class="panel-body">
							<div id="ke_sql_query">
								<form>
									<textarea id="code_current" name="code_current"></textarea>
								</form>
							</div>
						</div>
						<!-- /.panel-body -->
					</div>
				</div>
				<!-- /.col-lg-4 -->
			</div>
			<!-- /.row -->
			<div class="row">
				<div class="col-lg-12">
					<div class="panel panel-default">
						<div class="panel-heading">
							<i class="fa fa-comments fa-fw"></i> Result
							<div class="pull-right"></div>
						</div>
						<!-- /.panel-heading -->
						<div class="panel-body">
							<div id="ke_sql_query">
								<form>
									<textarea id="code_result" name="code_result"></textarea>
								</form>
							</div>
						</div>
						<!-- /.panel-body -->
					</div>
				</div>
				<!-- /.col-lg-4 -->
			</div>
		</div>
		<!-- /#page-wrapper -->
	</div>
</body>
<jsp:include page="../public/plus/script.jsp">
	<jsp:param value="plugins/magicsuggest/magicsuggest.js" name="loader" />
	<jsp:param value="plugins/tokenfield/bootstrap-tokenfield.js" name="loader" />
	<jsp:param value="plugins/codemirror/codemirror.js" name="loader" />
	<jsp:param value="plugins/codemirror/sql.js" name="loader" />
	<jsp:param value="plugins/codemirror/show-hint.js" name="loader" />
	<jsp:param value="plugins/codemirror/sql-hint.js" name="loader" />
	<jsp:param value="plugins/select2/select2.min.js" name="loader" />
	<jsp:param value="main/topic/hub.js" name="loader" />
	<jsp:param value="main/topic/ksql.history.js" name="loader" />
</jsp:include>
<jsp:include page="../public/plus/tscript.jsp"></jsp:include>
</html>
