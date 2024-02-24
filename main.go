package main

import (
	"fmt"

	"aerf.io/k8sutils"
	"sigs.k8s.io/yaml"

	corev1 "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes/scheme"
)

func main() {
	// use "old" version of "k8s.io/api/core/v1"
	obj := &corev1.ConfigMap{
		ObjectMeta: metav1.ObjectMeta{
			Name:      "name",
			Namespace: "ns",
		},
	}
	// use "old" version of k8sutils
	err := k8sutils.AddTypeInformationToObject(scheme.Scheme, obj)
	if err != nil {
		panic(err)
	}
	encoded, err := yaml.Marshal(obj)
	if err != nil {
		panic(err)
	}
	fmt.Println(string(encoded))
}
