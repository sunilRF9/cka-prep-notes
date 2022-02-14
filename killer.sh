# Multicontainer pod q13
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: multi-container-playground
  name: multi-container-playground
spec:
  containers:
  - image: nginx:1.17.6-alpine
    name: c1
    env:
    - name: MY_NODE_NAME
      valueFrom:
        fieldRef:
          fieldPath: spec.nodeName
    volumeMounts:
    - name: vol-mnt
      mountPath: "/tmp/"
  - image: busybox:1.31.1
    name: c2
    command: ["while true; do date >> /tmp/date.log; sleep 1; done"]
    volumeMounts:
    - name: vol-mnt
      mountPath: "/tmp/"
  - image: busybox:1.31.1
    name: c3
    command: ["tail -f /tmp/date.log"]
    volumeMounts:
    - name: vol-mnt
      mountPath: "/tmp/"
  volumes:
    - name: vol-mnt
      emptyDir: {}

# q4
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: ready-if-service-ready
  name: ready-if-service-ready
spec:
  containers:
  - image: nginx:1.16.1-alpine
    name: ready-if-service-ready
    livenessProbe:
      exec:
        command:
        - "sh"
        - "true"
    readinessProbe:
      exec:
        command:
        - "sh" 
        - "wget -T2 -O- http://service-am-i-ready:80"

#q24
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: np-backend
  namespace: project-snake
spec:
  podSelector:
    matchLabels:
      app: backend
  policyTypes:
  - Egress
  egress:
  - to:
    - podSelector:
        matchLabels:
          app: db1
    ports:
    - protocol: TCP
      port: 1111
  - to:
    - podSelector:
        matchLabels:
          app: db2
    ports:
    - protocol: TCP
      port: 2222

#q11
apiVersion: apps/v1
kind: DaemonSet
metadata:
  labels:
    app: ds-important
    id: ds-important
    uuid: 18426a0b-5f59-4e10-923f-c0e078e82462
  name: ds-important
  namespace: project-tiger
spec:
  selector:
    matchLabels:
      app: ds-important
  template:
    metadata:
      labels:
        app: ds-important
        id: ds-important
        uuid: 18426a0b-5f59-4e10-923f-c0e078e82462
    spec:
      containers:
      - image: httpd:2.4-alpine
        name: httpd
        resources: 
          requests:
            memory: "10Mi"
            cpu: "10m"
