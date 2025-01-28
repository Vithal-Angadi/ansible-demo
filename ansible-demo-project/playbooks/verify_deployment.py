import subprocess

def verify_namespace(namespace):
    try:
        result = subprocess.run(
            ["kubectl", "get", "pods", "-n", namespace],
            stdout=subprocess.PIPE,
            text=True
        )
        print(f"Namespace {namespace} Status:\n{result.stdout}")
    except Exception as e:
        print(f"Error verifying namespace {namespace}: {e}")

if __name__ == "__main__":
    namespaces = ["default", "argocd"]
    for ns in namespaces:
        verify_namespace(ns)
