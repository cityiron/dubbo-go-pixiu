// Copyright Istio Authors
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

package options

import (
	"github.com/apache/dubbo-go-pixiu/pilot/cmd/pilot-agent/status"
	"github.com/apache/dubbo-go-pixiu/pilot/cmd/pilot-agent/status/ready"
	"github.com/apache/dubbo-go-pixiu/pilot/pkg/model"
	istioagent "github.com/apache/dubbo-go-pixiu/pkg/istio-agent"
	meshconfig "istio.io/api/mesh/v1alpha1"
)

func NewStatusServerOptions(proxy *model.Proxy, proxyConfig *meshconfig.ProxyConfig, agent *istioagent.Agent) *status.Options {
	return &status.Options{
		IPv6:           proxy.IsIPv6(),
		PodIP:          InstanceIPVar.Get(),
		AdminPort:      uint16(proxyConfig.ProxyAdminPort),
		StatusPort:     uint16(proxyConfig.StatusPort),
		KubeAppProbers: kubeAppProberNameVar.Get(),
		NodeType:       proxy.Type,
		Probes:         []ready.Prober{agent},
		NoEnvoy:        agent.EnvoyDisabled(),
		FetchDNS:       agent.GetDNSTable,
		GRPCBootstrap:  agent.GRPCBootstrapPath(),
	}
}
