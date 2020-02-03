package MyApp::Controller::Root;
package MyApp::Model::DragDropDB;
use Moose;
use DBI;
use namespace::autoclean;
use Data::Dumper;

BEGIN { extends 'Catalyst::Controller' }

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config(namespace => '');

=encoding utf-8

=head1 NAME

MyApp::Controller::Root - Root Controller for MyApp

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 index

The root page (/)

=cut

sub index :Path :Global {
    my ( $self, $c ) = @_;
	$c->stash->{template} = 'index.tt';
}


sub login : Path : Args(0){
	my($self,$c)=@_;
	$c->stash->{'template'}='login.tt';
	my $username=$c->req->param('username');
	my $password=$c->req->param('password');
	if($username && $password){
		if(($username eq 'bwweb') && ($password eq 'Tr@ceWeb')){
			$c->res->redirect($c->uri_for('/index'));
			$c->stash->{'template'}='index.tt';
		}
		else{
			$c->stash->{'template'}='login.tt';
			$c->stash->{'message'}='Username and password not match';
		}
	}
	else{
        		$c->stash->{'template'} = 'login.tt';
	}
}

sub save: Local {
	my($self,$c)=@_;
	if ( $c->req->method eq 'POST' ){
		my $val =$c->req->param('txt_1');
		my $val1 =$c->req->param('txt_2');
		my @val3; my @val5; my @val6;
		my $dbh = DBI->connect("DBI:mysql:database=DragDropDB;host=localhost","prodata", 'data@123',{'RaiseError' => 1});
		# now retrieve data from the table.
		my $sth = $dbh->prepare("SELECT * FROM new_table");
		$sth->execute();
		while (my $ref = $sth->fetchrow_hashref()) {
		  #print "Found a row: id_table = $ref->{'id_table'}, name = $ref->{'name'}\n";
			push @val3,$ref->{'name'};
			push @val5, $ref->{'txtbx_val'};
		}
		$sth->finish();

		# Disconnect from the database.
		$dbh->disconnect();
		$c->stash->{'message_succ'}='';
		if($val&&$val1){
			#$c->stash->{'message'}=$val;
			#$c->stash->{'message1'}=$val1;
			#$c->stash->{'message2'}=Dumper \@val3;
			#$c->stash->{'message5'}=Dumper \@val5;
			#my $v= @val3;
			my $dbh = DBI->connect("DBI:mysql:database=DragDropDB;host=localhost","prodata", 'data@123',{'RaiseError' => 1});
			# same thing, but using placeholders (recommended!)
			my $new_id = $sth->{mysql_insertid};
			$dbh->do("INSERT INTO new_table  VALUES (?,?,?)", undef,$new_id++, $val1,$val);
			$dbh->disconnect();
			$c->stash->{'message_succ'}='Record Saved Successfully!!';
		}
		else{
			$c->stash->{'message'}='Failed';
		}
	}
	$c->stash->{'template'} ='index.tt';
}




sub view : Local{
	my($self,$c)=@_;
	$c->stash->{'template'}='view.tt';
	my $val11 =$c->req->param('txt_2');
	my @val3;my @val5;
	if ( $c->req->method eq 'POST' ){
		$c->stash->{'message'}=$val11;
		my $dbh = DBI->connect("DBI:mysql:database=DragDropDB;host=localhost","prodata", 'data@123',{'RaiseError' => 1});
		# now retrieve data from the table.
		my $sth = $dbh->prepare("SELECT * FROM new_table where name='$val11'");
		$sth->execute();
		while (my $ref = $sth->fetchrow_hashref()) {
		  #print "Found a row: id_table = $ref->{'id_table'}, name = $ref->{'name'}\n";
			push @val3,$ref->{'name'};
			push @val5, $ref->{'txtbx_val'};
		}
		$sth->finish();

		# Disconnect from the database.
		$dbh->disconnect();
		$c->stash->{'message2'}=Dumper \@val3;
		$c->stash->{'message5'}=Dumper \@val5;
	}
	else {
		$c->stash->{'message'}='failed';
	}
}

sub test : Local{
	my ($self,$c)=@_;
	$c->stash->{'template'}='emgjitest.tt';
}

sub update1 : Local{
	my ($self,$c)=@_;
	$c->stash->{'template'}='index.tt';
	my $val =$c->req->param('txt_1');
	my $val3 =$c->req->param('txt_3');
	my $val4 =$c->req->param('txt_6');
	my $sumval;
		if($c->req->param('txt_6') eq 'Update'){	
			$sumval= $val .', '. $val3;
		}
		else{
			if($c->req->param('txt_6') eq 'Delete'){	
				$sumval= $val ;
			}
		}
	my @ak = $val4;
	$c->stash->{'message_succ'}=Dumper \@ak;
}
sub update : Local{
	my ($self,$c)=@_;
	$c->stash->{'template'}='index.tt';
	my $val =$c->req->param('txt_1');
	my $val3 =$c->req->param('txt_3');
	my $val1 =$c->req->param('txt_2');
	my $sumval;
		if($c->req->param('txt_6') eq 'Update'){	
			$sumval= $val .', '. $val3;
		}
		else{
			if($c->req->param('txt_6') eq 'Delete'){	
				$sumval= $val ;
			}
		}
                if($sumval&&$val1){
		 	my $dbh = DBI->connect("DBI:mysql:database=DragDropDB;host=localhost","prodata", 'data@123',{'RaiseError' => 1});
                        # same thing, but using placeholders (recommended!)
                        #$dbh->do("UPDATE new_table SET txtbx_val=? WHERE  name=? ");
                        #$dbh->do("UPDATE new_table SET txtbx_val=? WHERE name=?");
			# update statement
			my $sql = "UPDATE new_table SET txtbx_val = ?  WHERE name = ?";
			my $sth = $dbh->prepare($sql);
			my $name = $val1;
			my $txtbx_val = $sumval;
			my @ashok = $txtbx_val;
			$sth->bind_param(1,$txtbx_val);
			$sth->bind_param(2,$name);
			$c->stash->{'message_succ1'}=Dumper \@ashok;
			$sth->execute();
			$dbh->disconnect();
		        $c->stash->{'message_succ'}='Record Updated Successfully!!';
                }
                else{
                        $c->stash->{'message_succ'}=$sumval;
                }
}

=head2 default

Standard 404 error page

=cut

sub default :Path {
    my ( $self, $c ) = @_;
    $c->response->body( 'Page not found' );
    $c->response->status(404);
}

=head2 end

Attempt to render a view, if needed.

=cut

sub end : ActionClass('RenderView') {}

=head1 AUTHOR

bw,learn,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
