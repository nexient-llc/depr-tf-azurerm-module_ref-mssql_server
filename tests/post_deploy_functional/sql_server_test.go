// Copyright 2022 Nexient LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package test

// Basic imports
import (
	"os"
	"path"
	"testing"

	"github.com/gruntwork-io/terratest/modules/azure"
	"github.com/gruntwork-io/terratest/modules/files"
	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
	"github.com/stretchr/testify/suite"
)

// Define the suite, and absorb the built-in basic suite
// functionality from testify - including a T() method which
// returns the current testing context
type TerraTestSuite struct {
	suite.Suite
	TerraformOptions *terraform.Options
}

// setup to do before any test runs
func (suite *TerraTestSuite) SetupSuite() {
	tempTestFolder := test_structure.CopyTerraformFolderToTemp(suite.T(), "../..", ".")
	_ = files.CopyFile(path.Join("..", "..", ".tool-versions"), path.Join(tempTestFolder, ".tool-versions"))
	pwd, _ := os.Getwd()
	suite.TerraformOptions = terraform.WithDefaultRetryableErrors(suite.T(), &terraform.Options{
		TerraformDir: tempTestFolder,
		VarFiles:     [](string){path.Join(pwd, "..", "demo.tfvars")},
	})

	terraform.InitAndApplyAndIdempotent(suite.T(), suite.TerraformOptions)
}

// TearDownAllSuite has a TearDownSuite method, which will run after all the tests in the suite have been run.
func (suite *TerraTestSuite) TearDownSuite() {
	terraform.Destroy(suite.T(), suite.TerraformOptions)
}

// In order for 'go test' to run this suite, we need to create
// a normal test function and pass our suite to suite.Run
func TestRunSuite(t *testing.T) {
	suite.Run(t, new(TerraTestSuite))
}

// All methods that begin with "Test" are run as tests within a suite.
func (suite *TerraTestSuite) TestOutputsWithAzureAPI() {

	actualServerId := terraform.Output(suite.T(), suite.TerraformOptions, "sql_server_id")
	actualServerFqdn := terraform.Output(suite.T(), suite.TerraformOptions, "sql_server_fqdn")
	actualServerName := terraform.Output(suite.T(), suite.TerraformOptions, "sql_server_name")
	actualServerAdminUsername := terraform.Output(suite.T(), suite.TerraformOptions, "admin_login_username")
	expectedSqlServerName := "demodb-eus-shared-000-dbser-000"
	expectedRgName := "demodb-eus-shared-000-rg-000"
	expectedServerAdminUsername := "nexientadmin001"
	// NOTE: "subscriptionID" is overridden by the environment variable "ARM_SUBSCRIPTION_ID". <>
	subscriptionID := ""
	server := azure.GetSQLServer(suite.T(), expectedRgName, expectedSqlServerName, subscriptionID)
	suite.Equal(*server.ID, actualServerId, "The Server IDs should match")
	suite.Equal(*server.Name, expectedSqlServerName, "The Server Name should match")
	suite.Equal(*server.AdministratorLogin, expectedServerAdminUsername, "The admin Server should match")
	suite.Equal(*server.FullyQualifiedDomainName, actualServerFqdn, "The FQDNs should match")

	suite.Equal(actualServerName, expectedSqlServerName, "The server Name tf output should match with input server name")
	suite.Equal(actualServerAdminUsername, expectedServerAdminUsername, "The admin username tf output should match with input server admin username")
}
