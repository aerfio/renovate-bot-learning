package v1alpha1

import (
	corev1 "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
)

type SampleSpec struct {
	Foo             string     `json:"foo"`
	EmbeddedPodSpec corev1.Pod `json:"embeddedPodSpec"`
}

//+kubebuilder:object:root=true

type Sample struct {
	metav1.TypeMeta   `json:",inline"`
	metav1.ObjectMeta `json:"metadata,omitempty"`

	Spec SampleSpec `json:"spec,omitempty"`
}

//+kubebuilder:object:root=true

type SampleList struct {
	metav1.TypeMeta `json:",inline"`
	metav1.ListMeta `json:"metadata,omitempty"`
	Items           []Sample `json:"items"`
}

func init() {
	SchemeBuilder.Register(&Sample{}, &SampleList{})
}
